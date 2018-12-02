defmodule Validators do
  @moduledoc """
  Модуль валидации регистрационных данных
  """

  @doc """
    Проверка ИНН на валидность.

    ## Examples

        iex> Validators.is_inn(nil)
        false

        iex> Validators.is_inn("")
        false

        iex> Validators.is_inn(1234567890)
        false

        iex> Validators.is_inn("123456")
        false

        iex> Validators.is_inn("0000000000")
        false

        iex> Validators.is_inn("000000000000")
        false

        iex> Validators.is_inn("7712040126")
        true

        iex> Validators.is_inn("132808730606")
        true

        iex> Validators.is_inn("732705632057")
        true

        iex> Validators.is_inn("abracadabraa")
        false

        iex> Validators.is_inn("abracadabr")
        false

  """
  def is_inn(nil), do: false
  def is_inn(""), do: false
  def is_inn(inn) when not is_bitstring(inn), do: false
  def is_inn(inn) when inn in ["0000000000", "000000000000"], do: false
  def is_inn(inn) do
    case String.length(inn) in [10,12] and Regex.match?(~r/^(?=[0-9]*$)(?:.{10}|.{12})$/, inn) do 
      true -> 
        inn 
        |> String.length
        |> inn_check(inn)
      _ -> false
    end
  end

  defp inn_check(length, inn) do
    case length do
      10 -> inn |> inn_check_ten
      _ -> inn |> inn_check_twelve
    end
  end

  defp inn_check_ten(inn) do
    checksum = inn 
    |> String.slice(0..-2) 
    |> inn_checksum

    inn
    |> String.last
    |> Kernel.==(checksum)
  end

  defp inn_check_twelve(inn) do
    checksum_one = inn
    |> String.slice(0..-3)
    |> inn_checksum

    checksum_two = inn
    |> String.slice(0..-2)
    |> inn_checksum

    inn
    |> String.slice(10,2)
    |> Kernel.==(checksum_one <> checksum_two)
  end

  defp inn_checksum(inn) do
    k = [3,7,2,4,10,3,5,9,4,6,8] 
    |> Enum.slice(11-String.length(inn)..-1)
    
    inn
    |> String.codepoints
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.zip(k)
    |> Enum.reduce(0, fn {x, y}, acc -> x * y + acc end)
    |> rem(11)
    |> rem(10)
    |> to_string
  end

  @doc """
    Проверка КПП на валидность.

    ## Examples

        iex> Validators.is_kpp(nil)
        false

        iex> Validators.is_kpp("")
        false

        iex> Validators.is_kpp(123456789)
        false

        iex> Validators.is_kpp("123456")
        false

        iex> Validators.is_kpp("000000000")
        false

        iex> Validators.is_kpp("997650001")
        true

        iex> Validators.is_kpp("abracadab")
        false

  """
  def is_kpp(nil), do: false
  def is_kpp(""), do: false
  def is_kpp(kpp) when not is_bitstring(kpp), do: false
  def is_kpp(kpp) when kpp == "000000000", do: false
  def is_kpp(kpp) do
    Regex.match?(~r/^[0-9]{4}[0-9A-Z]{2}[0-9]{3}$/, kpp)
  end

    @doc """
    Проверка ОГРН на валидность.

    ## Examples

        iex> Validators.is_ogrn(nil)
        false

        iex> Validators.is_ogrn("")
        false

        iex> Validators.is_ogrn(1234567890123)
        false

        iex> Validators.is_ogrn("123456")
        false

        iex> Validators.is_ogrn("0000000000000")
        false

        iex> Validators.is_ogrn("000000000000000")
        false

        iex> Validators.is_ogrn("1027700092661")
        true

        iex> Validators.is_ogrn("304390528700191")
        true

        iex> Validators.is_ogrn("304500116000221")
        true

        iex> Validators.is_ogrn("abracadabraaaaa")
        false

        iex> Validators.is_ogrn("abracadabraaa")
        false

  """
  def is_ogrn(nil), do: false
  def is_ogrn(""), do: false
  def is_ogrn(ogrn) when not is_bitstring(ogrn), do: false
  def is_ogrn(ogrn) when ogrn in ["0000000000000", "000000000000000"], do: false
  def is_ogrn(ogrn) do
    case String.length(ogrn) in [13, 15] and Regex.match?(~r/^(?=[0-9]*$)(?:.{13}|.{15})$/, ogrn)  do
      true ->
        ogrn 
        |> ogrn_delimeter
        |> ogrn_checksum(ogrn)
        |> Kernel.==(String.at(ogrn, -1))
      _ -> false
    end
  end

  defp ogrn_delimeter(ogrn) do
    ogrn
    |> String.length
    |> case do
      13 -> 11
      _ -> 13
    end
  end

  defp ogrn_checksum(delimeter, ogrn) do
    ogrn 
    |> String.slice(0..-2)
    |> String.to_integer
    |> rem(delimeter)
    |> rem(10)
    |> to_string
  end
end