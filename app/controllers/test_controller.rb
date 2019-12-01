require "redis"

class TestController < ApplicationController

    def function1 

        $redis.set("mykey", "hello world")
        if !$redis.get("testwrongkey") then
        render json: "yay" 
        end

    end

end
