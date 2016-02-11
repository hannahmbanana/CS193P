*** NOTE: Rather than do this assignment using Core Data (as intended in the directions below), I implemented the Top Regions features using objects. Core Data is not that commonly used, so I chose to get practice with objects instead. ***

Assignment VI: Top Regions

Objective 

In this assignment, we will enhance our Top Places application to store the information it fetches from Flickr into Core Data and then use that to our advantage to make some smart queries.

Be sure to review the Hints section below!

Required Tasks 

1. Your application must work identically to last week except that where you are displaying the “top places” (as reported by Flickr), you are going to display the “top regions” in which photos have been taken. You will calculate the most popular regions from the data you gather periodically from the URLforRecentGeoreferencedPhotos.

2. The popularity of a region is determined by how many different photographers have taken a photo in that region among the photos you’ve downloaded from Flickr. Only show the 50 most popular regions in your UI (it is okay if the table temporarily shows more than 50 as data is loaded into the database, but re-set it to 50 occasionally).

3. The list of top regions must be sorted first by popularity (most popular first, of course) and secondarily by the name of the region. Display the number of different photographers who have taken a photo in that region as a subtitle in each row.

4. When a region is chosen, all the photos in your database that were taken in that region should be displayed (no sections are required). When a photo is then chosen, it should be displayed in the same way photos were displayed in last week’s assignment.

5. All of your table views everywhere in your application (including the Recents tab) must be driven by Core Data (i.e. not NSUserDefaults nor Flickr dictionaries). You no longer have to support “pulling down to refresh” (though see Extra Credit 1).

6. You must use UIManagedDocument to store all of your Core Data information. In other words, you cannot use the NSManagedObjectContext-creating code from the demo.

7. Fetch the URLforRecentGeoreferencedPhotos from Flickr periodically (a few times an hour when your application is in the foreground and whenever the system will allow when it is in the background using the background fetching API in iOS). You must load this data into a Core Data database with whatever schema you feel you need to do the rest of this assignment.

8. Display a thumbnail image of a photo in any table view row that shows Flickr photo information. You must download these on demand only (i.e. do not ask for a thumbnail until the user tries to display that photo in a row). Once a thumbnail has been downloaded, you must store the thumbnail’s data in Core Data (i.e. don’t ask Flickr for it again). Don’t forget that table view cells are reused!

9. Do not store Flickr photos themselves (i.e. any image other than a thumbnail) in your Core Data database. Fetch them from Flickr on demand each time.

10. Your application’s main thread should never be blocked (e.g. all Flickr fetches must happen in a different thread). You can assume Core Data will not significantly block the main thread.

11. Your application must work in both portrait and landscape orientations on both the iPhone and the iPad and it must work on a real iOS device (not just the simulator). 