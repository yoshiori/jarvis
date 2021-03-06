require "ruboty/air_conditioner/version"
require "open_weather"

module Ruboty
  module Handlers
    class AirConditioner < Base
      on(
        /エアコン(付|つ)けて/,
        name: "start",
        description: "Start air conditioner."
      )

      on(
        /エアコン(止|と)めて/,
        name: "stop",
        description: "Stop air conditioner."
      )

      private

      def start(message)
        robot.receive(
          message.original.merge(
            body: "#{message.body[prefix]} irkit #{air_conditioner_command}"
          )
        )
      end

      def stop(message)
        robot.receive(
          message.original.merge(
            body: "#{message.body[prefix]} irkit stop_air_conditioner"
          )
        )
      end

      def air_conditioner_command
        temp > 15 ? "cooling_23" : "heating_23"
      end

      def temp
        OpenWeather::Current.city_id(1856950, APPID: ENV["OPEN_WEATHER_KEY"])["main"]["temp"] - 273.15
      end

      def prefix
        Ruboty::Action.prefix_pattern(robot.name)
      end
    end
  end
end
