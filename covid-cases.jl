### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 90d80b5e-0888-11eb-1447-49c261b7b456
begin
	using CSV
	using PlutoUI
	using ZipFile
	using Shapefile
	using DataFrames
	using LsqFit
end

# ╔═╡ a9dda4ca-088c-11eb-0e26-21573b8efb08
using Plots

# ╔═╡ 4873374e-0892-11eb-2997-f98c9b3cdfdf
using Dates



# ╔═╡ 6401fd40-0bc3-11eb-353f-8b74251630b7
md"# Covid dataset visualization"

# ╔═╡ 880f9c56-0bc3-11eb-37a5-dfc6c61e9085


# ╔═╡ 5cb92cf8-0895-11eb-01a9-e98613af5d45
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

# ╔═╡ 853cd78c-0bc3-11eb-0cfc-5319d08759b5


# ╔═╡ 30cd4534-0889-11eb-07e7-a3966aeadd24
download(url,"covid_data.csv")

# ╔═╡ 45e3dfa0-0889-11eb-0757-572d6c6b006e
begin
    data_csv = CSV.File("covid_data.csv")
	data = DataFrame(data_csv)
end

# ╔═╡ 8c137fbc-0889-11eb-01ef-9fc37e64ec71
names(data)

# ╔═╡ a83e4646-0a22-11eb-3b65-db0b9f951c6e


# ╔═╡ 60398098-0a15-11eb-0262-a3675d86b934
rename!(data,1 => :province,2=> :country,3=> :latitude,4=>:longitude)

# ╔═╡ 25c18032-088a-11eb-399b-190e7c2ca906
countries = unique(data[:,:country])

# ╔═╡ d9eadfd8-0a13-11eb-0d94-1f41684167c5


# ╔═╡ 31bfb54e-0a14-11eb-2a5d-81a1536c1598
first(countries)

# ╔═╡ a4e2b7d2-0894-11eb-3494-67d570927473
length(countries)

# ╔═╡ 42a76c48-088a-11eb-009d-e9df650d21ad
all_countries = (data[:,:country])

# ╔═╡ 6722a772-088a-11eb-1ca0-45c3ffbe6c3a
@bind coun Slider(1:length(countries))

# ╔═╡ 2439eb2a-0a22-11eb-0d07-116fcd5ab2df
coun

# ╔═╡ 8d2fda20-088a-11eb-1be1-9b90cad72dca
countries[coun]

# ╔═╡ a6761954-088a-11eb-3eb8-4b413b674a23
@bind country Select(countries)

# ╔═╡ bd9bed98-088a-11eb-12bb-5d4c41178cb8
U_countries = [startswith(country,"U") for country in all_countries]

# ╔═╡ e45f7404-088a-11eb-1d5e-15b9a67e2699
data[U_countries,:]

# ╔═╡ ffcc3f06-088a-11eb-04c4-f30cfffcc5d5


# ╔═╡ 3848fca2-088b-11eb-0a98-afdffd5a8e13
US_row = findfirst(==("US"),all_countries)

# ╔═╡ 5393b72e-088b-11eb-1a5f-bbe6f66e9d19
data[US_row,:]

# ╔═╡ c1dc1af8-088b-11eb-0d0e-57b9acf0509f
data[US_row:US_row,:]

# ╔═╡ d403949a-088b-11eb-2087-c5dabaebce34
US_data = Vector(data[US_row,5:end])

# ╔═╡ 4964c122-088d-11eb-390f-85c80b89f21c
India_row = findfirst(==("India"),all_countries)

# ╔═╡ 6edba7e0-088d-11eb-183c-d7e658ac2e04
begin
	pak_row = findfirst(==("Pakistan"),all_countries)
	pak_data = Vector(data[pak_row,5:end])
	bang_row = findfirst(==("Bangladesh"),all_countries)
	bang_data = Vector(data[bang_row,5:end])
	nepal_row = findfirst(==("Nepal"),all_countries)
	nepal_data = Vector(data[nepal_row,5:end])
	afg_row = findfirst(==("Afghanistan"),all_countries)
	afg_data = Vector(data[afg_row,5:end])
	chi_row = findfirst(==("China"),all_countries)
	chi_data = Vector(data[chi_row,5:end])

end

# ╔═╡ 6ec2cf90-088d-11eb-2fb5-ff38acdf8b3e
India_data = Vector(data[India_row,5:end])

# ╔═╡ 01858026-088d-11eb-3719-5167ed95b4cd
scatter(India_data,xlabel="days",ylabel="cumulative cases",log=false)

# ╔═╡ 3c1febc6-088e-11eb-3db3-2f0716523edc
begin
	scatter(US_data,leg=:topleft,label = "US",xlabel="days",ylabel="cumulative cases",log=false)
	scatter!(India_data,leg=:topleft,label = "India",xlabel="days",ylabel="cumulative cases",log=false)
	scatter!(pak_data,leg=:topleft,label = "Pakistan",xlabel=:"days",ylabel="cumulative cases",log=false)
	scatter!(bang_data,leg=:topleft,label = "bangladesh",xlabel=:"days",ylabel="cumulative cases",log=false)
	scatter!(nepal_data,leg=:topleft,label = "nepal",xlabel=:"days",ylabel="cumulative cases",log=false)
	scatter!(afg_data,leg=:topleft,label="Afghanistan",xlabel=:"days",ylabel="cumulative cases",log=false)
end

# ╔═╡ 2405363c-0892-11eb-32fc-976a7795f877
all_dates = names(data[:,5:end])

# ╔═╡ 4be2d194-0892-11eb-18e1-6d7d924c3e90
date_format = Dates.DateFormat("m/dd/YY")

# ╔═╡ 7b42d452-0892-11eb-1c5e-cbf27a4e8e97
parse(Date,all_dates[1],date_format)

# ╔═╡ fb359e8e-0893-11eb-15e0-89e7922489ed
dates = parse.(Date,all_dates,date_format) .+ Year(2000)

# ╔═╡ b14c24ba-0892-11eb-32c8-f331531d29e4
scatter(dates,India_data,leg=:topleft,label="India_data",xlabel="date",ylabel="cumulative cases")

# ╔═╡ d1984f36-0abe-11eb-385d-41064a6665e0
china_df = data[data["country"] .== "China",:]

# ╔═╡ 722f5714-0b9b-11eb-0d32-edc8541edd11
gd_china = groupby(china_df,:country)

# ╔═╡ 99110d04-0b9c-11eb-24b0-6304c5a7f818
china_totals = combine(gd_china,names(gd_china)[5:end] .=> sum)

# ╔═╡ e2eaba64-0b9d-11eb-395d-53bcc2316a65
china_data=Vector(china_totals[1,2:end])

# ╔═╡ 575232c8-0b9f-11eb-2dda-79d1322f9e16
scatter(dates,china_data)

# ╔═╡ b6d7bfb0-0b9f-11eb-1571-d5db836e1380
daily_cases =  diff(India_data)

# ╔═╡ d40023a0-0b9f-11eb-0a5f-e9e3ee075808
begin
	using Statistics
	running_mean = [mean(daily_cases[i-6:i]) for i=7:length(daily_cases)]
end

# ╔═╡ 3fca17fa-0ba0-11eb-2cc1-bba0cf870168
begin
	plot(dates[2:end],daily_cases,m=:o,leg=:topleft,label="raw data India",title="Daily cases",xlabel="date",alpha=0.5,ylabel="Daily Case Count")
end

# ╔═╡ 552edb12-0ba0-11eb-351e-f76cd1e2d180
begin
	plot(replace(daily_cases, 0=> NaN),m=:o,yscale=:log10,leg=:topleft,label="raw data India",title="Daily cases",xlabel="date",alpha=0.5,ylabel="Daily Case Count")
end

# ╔═╡ 56257cae-0ba2-11eb-1ee7-b134e555e882
length(running_mean)

# ╔═╡ 62758efe-0ba2-11eb-3894-2dd290e6c565
dates[80:150]

# ╔═╡ 78aa8cce-0ba2-11eb-2607-1dd2fce51857
model(x,p) = p[1].*exp.(p[2].*x)

# ╔═╡ ae1a0dee-0ba2-11eb-0230-e98e47ee2164
exp_period = 40:80

# ╔═╡ b809a48e-0ba2-11eb-3c3a-b35c29770090
begin
	p0  = [0.5,0.5]
	x_data = exp_period
	y_data = daily_cases[x_data]
	fit = curve_fit(model,x_data,y_data,p0)
end

# ╔═╡ 0950d71a-0ba3-11eb-1ba3-057e9538a55d
parameters = coef(fit)

# ╔═╡ 2a97479c-0ba3-11eb-0e1e-a31e16366925
begin
	plot(replace(daily_cases, 0 => NaN),m=:o,yscale=:log10,leg=:topleft,label="raw data India",title="Daily Cases",xlabel="date",alpha=0.5,ylabel="Daily Case count")
	xlims!(40,150)
	line_range=exp_period
	plot!(line_range,model(line_range,parameters),ls=:dash)
end

# ╔═╡ 476fef58-0ba4-11eb-09eb-61e77d5a4d49
province = data.province

# ╔═╡ 9bbcbd0c-0ba7-11eb-2f50-dd7fd5c11191
begin
	indices = ismissing.(province)
	province[indices] = all_countries[indices]
end

# ╔═╡ c06d615c-0bb7-11eb-2376-070adaba3da5
names(data)

# ╔═╡ d9fd3148-0ba7-11eb-22ac-a9e6e7c73ef0
begin
	scatter(data.longitude,data.latitude,leg=false,alpha=0.5,ms=2)
	for i=1:length(province)
		annotate!(data.longitude[i],data.latitude[i],text(province[i],:center,5,color=RGBA{Float64}(0.0,0.0,0.0,0.3)))
	end
	plot!(axes=false) 
end

# ╔═╡ c112954c-0ba7-11eb-133b-7b89e26725d4
begin
	maps_url="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip"
	zipfile = download(maps_url,"ne_110m_admin_0_countries.zip")
	r = ZipFile.Reader(zipfile)
	for f in r.files
		println("FileName:$(f.name)")
		open(f.name,"w") do io
			write(io,read(f))
		end
	end
	close(r)
end



# ╔═╡ 42c28614-0bae-11eb-33cd-17a8b239ad1d
shp_countries = Shapefile.shapes(Shapefile.Table("./ne_110m_admin_0_countries.shp"))

# ╔═╡ cb26aaa0-0baf-11eb-0b60-1d0614f670d4
plot(shp_countries,alpha=0.2)

# ╔═╡ 5f015bc6-0bb0-11eb-3fc6-af7c9a31b8eb
daily = max.(1,diff(Array(data[:,5:end]),dims=2))

# ╔═╡ 191f0d5c-0bb1-11eb-1a9b-a193ac863e09
@bind day2 Slider(1:size(daily,2),show_value=true)

# ╔═╡ 717ba424-0bb1-11eb-2cca-434ebffd7833
maximum(daily[:,day2])

# ╔═╡ 8e2ee590-0bb1-11eb-04db-83867748813a
log10(maximum(daily[:,day2]))

# ╔═╡ ac90cce2-0bb1-11eb-304f-4127f004ead0
dates[day2]

# ╔═╡ f20661ce-0bca-11eb-0725-27fdbc851a6e
@bind current_day Clock(0.5)

# ╔═╡ 034ae1da-0bcb-11eb-3ea6-553c449ec16c
dates[current_day]

# ╔═╡ ef9a65ae-0bb1-11eb-1d11-8b752189585c
world_plot = begin
	
	plot(shp_countries,alpha=0.2)
	scatter!(data.longitude,data.latitude,leg=false,ms=2*log10.(daily[:,current_day]))
	xlabel!("longitude")
	ylabel!("latitude")
	title!("Daily Cases in the world - $(dates[current_day])")
	
end

# ╔═╡ d238ff6e-13b8-11eb-19a2-ffdf5880c48f


# ╔═╡ 5fd30204-13b9-11eb-0148-d117e9ecfcff
gd_data = groupby(data,:country)

# ╔═╡ b960d52e-13b9-11eb-1a75-97b29f3ec31c
data_by_country = combine(gd_data,names(data)[5:end] .=> sum);

# ╔═╡ 86a8596c-13ba-11eb-3717-d724bfe2c1b3
@bind Country_Selector Select(countries)

# ╔═╡ f4af0df8-13b9-11eb-0eac-a75b91baf4ff


# ╔═╡ 0f2849ba-13ba-11eb-182b-5d8bd9cc9363
all_countries

# ╔═╡ a1193104-0bb8-11eb-1552-6dcb9e2c1631
covid_deaths_url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"

# ╔═╡ 991adbd2-0bc8-11eb-091a-059648bd39e7
download(covid_deaths_url,"covid19_deaths_global.csv")

# ╔═╡ 49a44fde-0bc3-11eb-1338-877cd693e0c6
begin
	country_data = data_by_country[data_by_country.country .== Country_Selector,
			2:end]
	country_data_vec = Vector(country_data[1,:])
	scatter(dates,country_data_vec,label=Country_Selector,leg=:topleft)
	xlabel!("date")
	ylabel!("cumulative cases")
end

# ╔═╡ 4955c526-0bc3-11eb-0cd4-17858f575b19
@bind Country_Selector2 Select(countries)

# ╔═╡ c851c40e-13bd-11eb-1124-9d22aea72d84


# ╔═╡ fb85f004-13bb-11eb-1b2e-8d2c8573c974
begin
	country_data2 = data_by_country[data_by_country.country .== Country_Selector2,
			2:end]
	country_data_vector = Vector(country_data[1,:])
	scatter(dates,country_data_vector,label=Country_Selector2,leg=:topleft)
	xlabel!("date")
	ylabel!("cumulative deaths")
end

# ╔═╡ fb763ad8-13bb-11eb-27a5-298883c37792


# ╔═╡ eb7aa68c-17a8-11eb-0568-ffe5af9172e3


# ╔═╡ fea35008-28d9-11eb-0820-ef0fd3ca3dfa


# ╔═╡ Cell order:
# ╟─6401fd40-0bc3-11eb-353f-8b74251630b7
# ╠═90d80b5e-0888-11eb-1447-49c261b7b456
# ╠═880f9c56-0bc3-11eb-37a5-dfc6c61e9085
# ╠═5cb92cf8-0895-11eb-01a9-e98613af5d45
# ╠═853cd78c-0bc3-11eb-0cfc-5319d08759b5
# ╠═30cd4534-0889-11eb-07e7-a3966aeadd24
# ╠═45e3dfa0-0889-11eb-0757-572d6c6b006e
# ╠═8c137fbc-0889-11eb-01ef-9fc37e64ec71
# ╠═a83e4646-0a22-11eb-3b65-db0b9f951c6e
# ╠═60398098-0a15-11eb-0262-a3675d86b934
# ╠═25c18032-088a-11eb-399b-190e7c2ca906
# ╠═d9eadfd8-0a13-11eb-0d94-1f41684167c5
# ╟─31bfb54e-0a14-11eb-2a5d-81a1536c1598
# ╟─a4e2b7d2-0894-11eb-3494-67d570927473
# ╠═42a76c48-088a-11eb-009d-e9df650d21ad
# ╠═6722a772-088a-11eb-1ca0-45c3ffbe6c3a
# ╠═2439eb2a-0a22-11eb-0d07-116fcd5ab2df
# ╠═8d2fda20-088a-11eb-1be1-9b90cad72dca
# ╠═a6761954-088a-11eb-3eb8-4b413b674a23
# ╠═bd9bed98-088a-11eb-12bb-5d4c41178cb8
# ╠═e45f7404-088a-11eb-1d5e-15b9a67e2699
# ╠═ffcc3f06-088a-11eb-04c4-f30cfffcc5d5
# ╠═3848fca2-088b-11eb-0a98-afdffd5a8e13
# ╠═5393b72e-088b-11eb-1a5f-bbe6f66e9d19
# ╠═c1dc1af8-088b-11eb-0d0e-57b9acf0509f
# ╠═d403949a-088b-11eb-2087-c5dabaebce34
# ╠═a9dda4ca-088c-11eb-0e26-21573b8efb08
# ╠═01858026-088d-11eb-3719-5167ed95b4cd
# ╠═4964c122-088d-11eb-390f-85c80b89f21c
# ╠═6edba7e0-088d-11eb-183c-d7e658ac2e04
# ╠═6ec2cf90-088d-11eb-2fb5-ff38acdf8b3e
# ╠═3c1febc6-088e-11eb-3db3-2f0716523edc
# ╠═2405363c-0892-11eb-32fc-976a7795f877
# ╠═4873374e-0892-11eb-2997-f98c9b3cdfdf
# ╠═4be2d194-0892-11eb-18e1-6d7d924c3e90
# ╠═7b42d452-0892-11eb-1c5e-cbf27a4e8e97
# ╠═fb359e8e-0893-11eb-15e0-89e7922489ed
# ╠═b14c24ba-0892-11eb-32c8-f331531d29e4
# ╠═d1984f36-0abe-11eb-385d-41064a6665e0
# ╠═722f5714-0b9b-11eb-0d32-edc8541edd11
# ╠═99110d04-0b9c-11eb-24b0-6304c5a7f818
# ╠═e2eaba64-0b9d-11eb-395d-53bcc2316a65
# ╠═575232c8-0b9f-11eb-2dda-79d1322f9e16
# ╠═b6d7bfb0-0b9f-11eb-1571-d5db836e1380
# ╠═d40023a0-0b9f-11eb-0a5f-e9e3ee075808
# ╠═3fca17fa-0ba0-11eb-2cc1-bba0cf870168
# ╠═552edb12-0ba0-11eb-351e-f76cd1e2d180
# ╠═56257cae-0ba2-11eb-1ee7-b134e555e882
# ╠═62758efe-0ba2-11eb-3894-2dd290e6c565
# ╠═78aa8cce-0ba2-11eb-2607-1dd2fce51857
# ╠═ae1a0dee-0ba2-11eb-0230-e98e47ee2164
# ╠═b809a48e-0ba2-11eb-3c3a-b35c29770090
# ╠═0950d71a-0ba3-11eb-1ba3-057e9538a55d
# ╠═2a97479c-0ba3-11eb-0e1e-a31e16366925
# ╠═476fef58-0ba4-11eb-09eb-61e77d5a4d49
# ╠═9bbcbd0c-0ba7-11eb-2f50-dd7fd5c11191
# ╠═c06d615c-0bb7-11eb-2376-070adaba3da5
# ╠═d9fd3148-0ba7-11eb-22ac-a9e6e7c73ef0
# ╠═c112954c-0ba7-11eb-133b-7b89e26725d4
# ╠═42c28614-0bae-11eb-33cd-17a8b239ad1d
# ╠═cb26aaa0-0baf-11eb-0b60-1d0614f670d4
# ╠═5f015bc6-0bb0-11eb-3fc6-af7c9a31b8eb
# ╠═191f0d5c-0bb1-11eb-1a9b-a193ac863e09
# ╠═717ba424-0bb1-11eb-2cca-434ebffd7833
# ╠═8e2ee590-0bb1-11eb-04db-83867748813a
# ╠═ac90cce2-0bb1-11eb-304f-4127f004ead0
# ╠═f20661ce-0bca-11eb-0725-27fdbc851a6e
# ╠═034ae1da-0bcb-11eb-3ea6-553c449ec16c
# ╠═ef9a65ae-0bb1-11eb-1d11-8b752189585c
# ╠═d238ff6e-13b8-11eb-19a2-ffdf5880c48f
# ╠═5fd30204-13b9-11eb-0148-d117e9ecfcff
# ╠═b960d52e-13b9-11eb-1a75-97b29f3ec31c
# ╠═86a8596c-13ba-11eb-3717-d724bfe2c1b3
# ╠═f4af0df8-13b9-11eb-0eac-a75b91baf4ff
# ╠═0f2849ba-13ba-11eb-182b-5d8bd9cc9363
# ╠═a1193104-0bb8-11eb-1552-6dcb9e2c1631
# ╠═991adbd2-0bc8-11eb-091a-059648bd39e7
# ╠═49a44fde-0bc3-11eb-1338-877cd693e0c6
# ╠═4955c526-0bc3-11eb-0cd4-17858f575b19
# ╠═c851c40e-13bd-11eb-1124-9d22aea72d84
# ╠═fb85f004-13bb-11eb-1b2e-8d2c8573c974
# ╠═fb763ad8-13bb-11eb-27a5-298883c37792
# ╠═eb7aa68c-17a8-11eb-0568-ffe5af9172e3
# ╠═fea35008-28d9-11eb-0820-ef0fd3ca3dfa
