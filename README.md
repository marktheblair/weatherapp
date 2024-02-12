# Weather Demonstration Application

## Summary
This is a Ruby on Rails application that allows users to input addresses and then displays the current weather and weather forcast for those addresses.  Addresses are created and stored in the application database.  When a user chooses an address from the list of available addresses, the address details and the weather/forcast for that address are displayed.  Addresses can be deleted from the system.

The purpose of this application is to show a working Ruby on Rails application that stores address data, retrieves additional weather data from an outside API, and displays the combined data to the user using standard server side rendered HTML.  The application also includes code that allows a client to perform all the same operations using a REST API and receiving output in JSON format, so an outside client can render its own inteface (such as a React application).  Tests are included at all levels to ensure the application is working correctly.  The data coming back from the weather api is cached for 30 minutes.

This [pull request](https://github.com/marktheblair/weatherapp/pull/1) shows all the added application code.

### Screen Shots

#### Home Page
![Screenshot 2024-02-12 at 3 39 30 PM](https://github.com/marktheblair/weatherapp/assets/885281/bc30951f-7e46-4e7a-9b0f-9164fea14555)

#### New Address Page
![Screenshot 2024-02-12 at 3 39 57 PM](https://github.com/marktheblair/weatherapp/assets/885281/f2947446-ddee-4eeb-88ca-863425a12e19)

#### Address Detail Page
![Screenshot 2024-02-12 at 3 40 11 PM](https://github.com/marktheblair/weatherapp/assets/885281/d2384f8e-4aa1-4d93-aef4-24b025de9d30)

## Installing and Running the Application

The following steps will install and application:

1.  Clone the application repository
```sh
$ git clone git@github.com:marktheblair/weatherapp.git
```

2.  Install the all the gems needed to run the application

```sh
$ cd weatherapp
$ bundle
```
3.  Create the database

```sh
$ rake db:migrate
```

4.  Enable caching in the development environment

```sh
$ touch ./tmp/caching-dev.txt
```

5.  Run the rails application

```sh
$ rails s
```

6. Open browswer to http://localhost:3000, this will show the main page for the application.

7.  NOTE:  The test suite can be run at the command line using:
```sh
$ rspec
```


## Using the Application

The application main page will show a list of addresses that are currently stored in the system.  At this point, there will not be any addresses to show since this is the first time the application is run.  

To use the application:

1.  At the top navigation, click on "New Address".
2.  An address input form will appear, fill out the fields with valid data, and press the "Create" button
3.  The browser will be redirected to the Address detail page, which shows the inputed data along with the weather for that address.  This intial weather information is obtained directly from the Open Weather Api and cached for 30 minutes.
4.  Refresh the address detail page, and a "Cached" badge will appear indicating the weather data has been read from the cache for this page load.
5.  Click on "Addresses" at the top of the page, and the browser will return inital page, showing a list of addresses stored in the system.  Clicking on an address will take you to the detail page for that address.

## Application Architecture

### MVC Pattern

The application uses the Model-View-Controller design pattern as implemented by the Ruby on Rails platform.  The following components are used:

#### Models

 - [Address](/app/models/address.rb) - model used to store addresses created by the user

 #### Views

 - Addresses
    - [index](/app/views/addresses/index.html.erb) - list of addresses stored in the database
    - [show](/app/views/addresses/show.html.erb) - detail view of an address
    - [new](/app/views/addresses/new.html.erb) - form to enter a new address

#### Controllers

- [Addresses](/app/controllers/addresses_controller.rb) - receives user requests, uses models/views to generate HTML output
- [Api::Addresses](/app/controllers/api/addresses_controller.rb) - receives user requests, uses models to generate JSON output

### Services Layer Pattern

The application uses a Service class to interface with the Open Weather Api.  The class returns plain ruby objects (Arrays and Hashes) to abstract away Open Weather Client, allowing for easily replacing it with another client in the future.

- [WeatherService](/app/services/weather_service.rb) - retrieves weather data for a zipcode from the Open Weather Api.

## Testing

### Rspec 

Rspec is used to build the test suite.

#### Model Specs

- [address_spec](/spec/models/address_spec.rb) - unit tests for the Address model

#### Controller Specs

- [addresses_spec](/spec/requests/addresses_spec.rb) - tests for the Addresses Controller
- [api/addresses_spec](/spec/requests/api/addresses_spec.rb) - tests for the Addresses Api Controller

#### Service Specs
- [weather_service_spec](/spec/services/weather_service_spec.rb) - tests for the weather service

### VCR

The VCR gem is used to mock the API output of the Open Weather API.  This is to ensure that the tests can run without needing the Open Weather API every time it runs.

## Open Weather API client

The open-weather-ruby-client is used to access the Open Weather Api version 2.5.  This is the free version of their API.  A key is needed to access the the Open Weather Api, and is included in this repository in the encrypted environment file.

SPECIAL NOTE:  The rails [master.key](/config/master.key) file has been included in the repository for easy decrypting of the Open Weather Api key.  Normally, THIS SHOULD NOT BE DONE, but was done to make it easier to just run the application.

### open-weather-ruby-client mixin

There is a small mixin in the lib directory for the open-weather-ruby-client gem.  The gem did not implement access to the version 2.5 forcast api, so a mixin was needed to add that functionality.  This allowed the application to use the free version of the api and get the forcast data needed.

- [forcast.rb](/lib/open_weather/endpoints/forcast.rb) - code to add retrieving 2.5 forcast data from Open Weather api

## Platform and Library Versions

This application primarily uses the following libraries:

 - Ruby on Rails (7.1.3) - Main application platform
 - Open Weather Ruby Client (0.4.0) - Client for retrieving weather data
 - Rspec / Rspec-Rails (3.1.2 / 6.1.1) - Testing platform
 - BootStrap (5.1.3) - CSS Styling for Server Side Rendering
 - Rubocop (1.60.2) - Ruby Code Formatter and Analyzer

 There are other gems and libraries in use, but these are the primary ones.
