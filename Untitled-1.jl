using Base: String
using StatsBase

mutable struct weather
    # weather struct holds the user friendly condition string, forecast is the list of all weather structs,
    # probability is the chance that during any given weather condition what is the chance of getting any other one
    condition::String
    forecast::Array
    probability::Array
end

function dailyweather(;Sunny_condtion::String = "Sunny", Cloudy_condition::String = "Cloudy", Rainy_condition::String = "Raining",
                    Sunny_prob::Array = [0.7, 0.2, 0.1], Cloudy_prob::Array = [1/3, 1/3, 1/3], Rainy_prob::Array = [0.2, 0.4, 0.4],
                    Seasonlength::Int = 90)

    # create different weather structs with the provided or default info
    Sunny = weather(Sunny_condtion, [], Sunny_prob)
    Cloudy = weather(Cloudy_condition, [], Cloudy_prob)
    Rainy = weather(Rainy_condition, [], Rainy_prob)

    # create a list of the weathers to be inserted into the forecast of each weather
    Weather_forecast = [Sunny, Cloudy, Rainy]

    # inster the list into forecast for each weather
    Sunny.forecast = Cloudy.forecast = Rainy.forecast = Weather_forecast

    # need to declare a starting weather
    Current_weather = rand(Weather_forecast)

    # an empty list to hold the history of the season
    History = []
    
    for i in 1:Seasonlength
        # set the current weather to a random one based on the weights of the current weather
        Current_weather = sample(Current_weather.forecast, weights(Current_weather.probability))
        # add the current condition to the history to access later
        push!(History, Current_weather.condition)
    end
    return History
end

function occurencerange(Value::Int, Start::Int, Stop::Int; Width::Int = 2)
    # a function to determine if a random event happens, start and stop provide two values from which the mean is found
    # width indicates number of SD from the mean to the start or stop point
    Avg = mean([Start, Stop])
    SD = (Stop - Avg) / Width
    # ex: if building a house requires at least 10 people and is almost certain after 20 people then
    # Value = current_population, Start = 10, Stop = 20
    return Value > randn() * SD + Avg
end

function population(Current_pop::Int, Growth_factors::Union{Array, Int}, Shrink_factors::Union{Array, Int})
    return floor(Current_pop * exp(sum(Growth_factors) - sum(Shrink_factors)))
end

Growth_factors = Dict(
    # To access multiple values use [Growth_factors[i] for i in [list_of_keys]]
    #Natural events
    "Mild Weather" => 0.1,
    "Good rains" => 0.2
)


