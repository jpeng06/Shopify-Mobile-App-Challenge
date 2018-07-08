# Shopify Mobile App Challenge  

## Requirement 

Create a mobile app that displays an Order Summary Page. Your summary will show the following 2 categories:

- Orders by Province: Number of orders from each province
Each province will be its own subheading. So, “Orders by Province” will be the heading and “x number of orders from Alaska”, for example, will be the subheading. The number of subheadings depends on how many different provinces the orders were shipped to.

- Orders by Year: Number of orders created in 2017

You can access the list of orders, and their properties, via the Shopify Orders List REST API. Reading through the properties’ descriptions will help you determine how to categorize orders in each category. It is possible for a single order to be in more than one category.

Doc: https://docs.google.com/document/d/1oaJN3JNlbvRuljFafPNwzh-n6y1KxYCEkITCEt1Ngl0/edit?ts=5ae0b305

## API

https://shopicruit.myshopify.com/admin/orders.json

### Parameters  

* page=1
* access_token=c32313df0d0ef512ca64d5b336a0d7c6



## Layout

- The top left icon is to change how the list should be sorted. Two options are provided: order by year and order by province.

- the top right icon is to go to next page

## Enhancement 

I don't have a lot of time for this project at this moment but I keep updating during the break from my work

- Add order detail view when user taps each order summary cell
- Show pages on how view controller and add previous button to let user go back to previous page
- Add more sorting options (sort by items numbers, price, etc.)

## Use Case

I was assuming that end user will be the person who prepares customers' order at warehouse. Some sample user cases would be:
- check the name of the person who placed this order
- check address of this order
- check date of this order
- check total amount of purchases  

## Technology

- Written in Switch 3 
- No 3rd party libraries were used
- Core data is added for later implementations 
- background colours are randomly assigned 

## Demo


<img src="https://github.com/jpeng06/Shopify-Mobile-App-Challenge/blob/master/demo/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-07-08%20at%2000.07.04.png" width="30%">
<img src="https://github.com/jpeng06/Shopify-Mobile-App-Challenge/blob/master/demo/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-07-08%20at%2000.07.23.png" width="35%">
<img src="https://github.com/jpeng06/Shopify-Mobile-App-Challenge/blob/master/demo/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-07-08%20at%2000.07.27.png" width="35%">
<img src="https://github.com/jpeng06/Shopify-Mobile-App-Challenge/blob/master/demo/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-07-08%20at%2000.07.34.png" width="35%">

2018 © John Peng
