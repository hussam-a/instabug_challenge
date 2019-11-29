# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

i=0
5.times do 
    i=i+1
    App.create({name: "App" + i.to_s,token: "t"+i.to_s})
        j=0
        5.times do 
            j=j+1
            Chat.create({app_id: App.last.id, chat_number:j}) 
            k = 0
            5.times do
                k = k + 1
                Message.create({chat_id:Chat.last.id,message_number:k,
                    content:"App" + i.to_s + " Chat" + j.to_s + " Message" + k.to_s})
            end
    end 
end