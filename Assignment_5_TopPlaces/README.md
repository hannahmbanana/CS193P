Assignment V: Top Places

Objective 

In this assignment, you will create an application that presents a list of popular Flickr photo spots and then allow the user to see some photos taken in those spots.

The primary work to be done in this assignment is to create a tab-based user-interface with two tabs: Top Places and Recents. The first tab will allow the user to view which places on Earth have been the most popular for taking photos posted to Flickr and then look at some photos from those places. The second tab will let the user go back and see his or her most recently-viewed (inside your application) photos.

The goals are to get familiar with table views, scroll view, image view and multithreading and to learn how to build a Universal application that runs on both iPhone and iPad (with appropriate UIs on each).

All the data you need will be downloaded from Flickr.com using Flickr’s API. Code will be provided which can build URLs for the Flickr queries you need for this assignment.

Be sure to review the Hints section below!

Required Tasks 

1. Download the data at the URL provided by the FlickrFetcher class method URLforTopPlaces to get an array of the most popular Flickr photo spots in the last day or so. See the Hints for how to interpret data returned by Flickr.

2. Create a UITabBarController-based user-interface with two tabs. The first tab shows a UITableView listing the places obtained above divided into sections by country and then alphabetical within each section. The second tab shows a UITableView with a list of the 20 most recently viewed (in your application) photos (in chronological order with the most-recently-viewed first and no duplicates).

3. Anywhere a place appears in a table view in your application, the most detailed part of the location (e.g. the city name) should be the title of the table view’s cell and the rest of the name of the location (e.g. state, province, etc.) should appear as the subtitle of the table view cell. The country will be in the section title.

4. When the user chooses a place in a table view, you must query Flickr again to get an array of 50 photos from that place and display them in a list. The URL provided by FlickrFetcher’s URLforPhotosInPlace:maxResults: method will get this from Flickr.

5. Any list of photos should display the photo’s title as the table view cell’s title and its description as the table view cell’s subtitle. If the photo has no title, use its description as the title. If it has no title or description, use “Unknown” as the title. Flickr photo dictionary keys are #defined in FlickrFetcher.h.

6. When the user chooses a photo from any list, show it inside a scrolling view that allows the user to pan and zoom (a reasonable amount). You obtain the URL for a Flickr photo’s image using FlickrFetcher’s URLForPhoto:format:.

7. Make sure the photo’s title is somewhere on screen whenever you are showing a photo image to the user.

8. Whenever a photo’s image appears on screen, it should automatically zoom to show as much of the photo as possible with no extra, unused space. Once the user zooms in or out on a photo by pinching, though, you can stop auto-zooming that image.

9. Your application’s main thread should never be blocked (e.g. Flickr fetches must happen in a different thread). If your application is waiting for something over the network, it should give feedback to the user that that is happening.

10. Your application must work in both portrait and landscape orientations on both the iPhone and the iPad. Use appropriate platform-specific UI idioms (e.g. don’t let your iPad version look like a gigantic iPhone screen).

11. The list of recent photos should be saved in NSUserDefaults (i.e. it should be persistent across launchings of your application). Conveniently, the arrays you get back from the FlickrFetcher URLs are all property lists (once converted from JSON).

12. You must get your application working on a real iOS device this week. 