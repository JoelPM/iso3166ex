defmodule ISO3166 do
  @title "ISO_3166-1"
  @section "4"
  @revid "690144849"
  @url "https://en.wikipedia.org/w/api.php?action=parse&section=#{@section}&prop=text&format=json&formatversion=2&oldid=#{@revid}"

  @region_file_name Path.expand("../priv/ISO_3166-2.csv", __DIR__)
  @file_cache Path.expand("../priv/#{@title}.#{@section}.#{@revid}.html", __DIR__)

  unless File.exists? @file_cache do
    :inets.start()
    {:ok, {_status, _headers, content}} = :httpc.request String.to_charlist(@url)
    {:ok, json} = Poison.decode content
    html = json["parse"]["text"]
    File.write! @file_cache, html
  end

  [{"table", _, rows}] = @file_cache |> File.read! |> Floki.parse |> Floki.find("table.sortable")
  {:ok, region_rows} = @region_file_name |> File.read! |> ExCsv.parse

  tuple = fn (name, abr2, abr3) ->
    {name, String.downcase(abr2), String.downcase(abr3)}
  end

  @mappings Enum.reduce(rows, [], fn row, acc ->
    case row do
      {"tr", _, [{"td",_,[{"a", _, [name]}]}, {"td", _, [{"a", _, [{"span", _, [abr2]}]}]}, {"td", _, [{"span", _, [abr3]}]},_,_]} ->
        [tuple.(name, abr2, abr3) | acc]
      {"tr", _, [{"td",_,[_, {"span", _, [{"a", _, [name]}]}]}, {"td", _, [{"a", _, [{"span", _, [abr2]}]}]}, {"td", _, [{"span", _, [abr3]}]},_,_]} ->
        [tuple.(name, abr2, abr3) | acc]
      {"tr", _, [{"th",_,_}, {"th",_,_}, {"th",_,_}, {"th",_,_}, {"th",_,_}]} ->
        acc
    end
  end) |> Enum.reverse

  @regions region_rows.body

  defp is_downcase?(str), do: str == String.downcase(str)
  defp is_upcase?(str), do: str == String.upcase(str)

  Enum.each @regions, fn ([country, region, code]) ->
    defp do_region(unquote(String.downcase(code))), do: {unquote(country), unquote(region)}
  end
  defp do_region(_), do: :undefined

  # generate the functions that map 2 letter abbreviation to 3
  # letter abreviation with a catchall that returns :undefined
  Enum.each @mappings, fn {_name, abr2, abr3} ->
    defp do_cc2to3(unquote(abr2)), do: unquote(abr3)
  end
  defp do_cc2to3(_), do: :undefined

  # generate the functions that map 3 letter abbreviation to 2
  # letter abreviation with a catchall that returns :undefined
  Enum.each @mappings, fn {_name, abr2, abr3} ->
    defp do_cc3to2(unquote(abr3)), do: unquote(abr2)
  end
  defp do_cc3to2(_), do: :undefined

  # generate the functions that map 2 letter abbreviation to
  # name with a catchall that returns :undefined
  Enum.each @mappings, fn {name, abr2, _abr3} ->
    defp do_cc2toname(unquote(abr2)), do: unquote(name)
  end
  defp do_cc2toname(_), do: :undefined

  # generate the functions that map 3 letter abbreviation to
  # name with a catchall that returns :undefined
  Enum.each @mappings, fn {name, _abr2, abr3} ->
    defp do_cc3toname(unquote(abr3)), do: unquote(name)
  end
  defp do_cc3toname(_), do: :undefined

  # matches the case of the input if it's all upper or lower
  defp do_with_matching_case(v, func) do
    case is_downcase?(v) do
      true  -> func.(v)
      false ->
        val = v |> String.downcase |> func.()
        case val do
          :undefined -> :undefined
          _ ->
            case is_upcase?(v) do
              true -> String.upcase val
              false -> val
            end
        end
    end
  end

  # converts input to lowercase and executes the func
  defp do_with_proper_case(v, func) do
    v |> String.downcase |> func.()
  end

  def all, do: @mappings
  def regions, do: @regions

  def cc2to3(v), do: do_with_matching_case v, &do_cc2to3/1

  def cc3to2(v), do: do_with_matching_case v, &do_cc3to2/1

  def cc2toname(v), do: do_with_proper_case v, &do_cc2toname/1

  def cc3toname(v), do: do_with_proper_case v, &do_cc3toname/1

  def parse_region(v), do: do_with_proper_case v, &do_region/1
end
