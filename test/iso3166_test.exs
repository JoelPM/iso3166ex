defmodule ISO3166Test do
  use ExUnit.Case
  doctest ISO3166

  test "2 char to 3 char abbreviations" do
    Enum.each ISO3166.all, fn {_name, abr2, abr3} ->
      assert ISO3166.cc2to3(abr2) == abr3
      assert ISO3166.cc2to3(String.capitalize(abr2)) == abr3
      assert ISO3166.cc2to3(String.upcase(abr2)) == String.upcase(abr3)
    end
    assert ISO3166.cc2to3("YY") == :undefined
    assert ISO3166.cc2to3("xx") == :undefined
  end

  test "3 char to 2 char abbreviations" do
    Enum.each ISO3166.all, fn {_name, abr2, abr3} ->
      assert ISO3166.cc3to2(abr3) == abr2
      assert ISO3166.cc3to2(String.capitalize(abr3)) == abr2
      assert ISO3166.cc3to2(String.upcase(abr3)) == String.upcase(abr2)
    end
    assert ISO3166.cc3to2("YYY") == :undefined
    assert ISO3166.cc3to2("xxx") == :undefined
  end

  test "3 char to name" do
    Enum.each ISO3166.all, fn {name, _abr2, abr3} ->
      assert ISO3166.cc3toname(abr3) == name
      assert ISO3166.cc3toname(String.capitalize(abr3)) == name
      assert ISO3166.cc3toname(String.upcase(abr3)) == name
    end
    assert ISO3166.cc3toname("YYY") == :undefined
    assert ISO3166.cc3toname("xxx") == :undefined
  end

  test "2 char to name" do
    Enum.each ISO3166.all, fn {name, abr2, _abr3} ->
      assert ISO3166.cc2toname(abr2) == name
      assert ISO3166.cc2toname(String.capitalize(abr2)) == name
      assert ISO3166.cc2toname(String.upcase(abr2)) == name
    end
    assert ISO3166.cc2toname("YYY") == :undefined
    assert ISO3166.cc2toname("xxx") == :undefined
  end
end
