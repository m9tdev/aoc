date = Date.utc_today()

url = "https://adventofcode.com/#{date.year}/day/#{date.day}/input"

session_token = System.get_env("AOC_SESSION_TOKEN")

headers = [
  {"Cookie",
  "session=#{session_token}"},
]

year_num = Integer.to_string(date.year - 2000)
day_num = String.pad_leading("#{date.day}", 2, "0")
destination = "lib/mm#{year_num}/day#{day_num}/input.txt"

case HTTPoison.get(url, headers) do
  {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    File.write(destination, body)
    IO.puts("File downloaded successfully to #{destination}")
  {:ok, %HTTPoison.Response{status_code: code}} ->
    IO.puts("Failed to download file. HTTP Status Code: #{code}")
  {:error, %HTTPoison.Error{reason: reason}} ->
    IO.puts("Failed to download file. Error: #{reason}")
end
