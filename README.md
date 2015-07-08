# Tournament README #

### What is this repository for? ###
When I started working on this app I wasn't able to find a good example of how to setup tournament brackets. So, I wanted to create a resource for other developers to use for their own apps.

### How do I get set up? ###

1. ####Create a Parse App####
    1. Goto [Parse.com](https://www.parse.com/) and signup/login.
    2. Click on create a new app
    3. Give it a name. I use "Tournament"

1. ####Create keys.plist####
    1. Right click on Supporting Files New File > Resource > Property List.
    2. Name it "keys" and save it to any location you wish.
    3. Add "parseClientKey" and "parseApplicationId". 
    
1. ####update keys.plist####
    1. From the Parse dashboard hoover over the gear icon for the related app
    2. Select Keys
    3. parseApplicationId needs the value from Application ID
    4. parseClientKey needs the value from Client Key


### TODO  ###

* Add more comments to make the app friendlier to knew people
* Add the ability to create double elimination tournaments
* Be able to see the tournaments you participated in not just the ones created
* When a participant is created check to see if parse has that user and user the parse user if so
* Add the ability to notifiy a user when it is their turn to play(would require the user to have create a parse user)

### Who do I talk to? ###
Current primary developer can be reached at heckert@ludomade.com
