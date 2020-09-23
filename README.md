# FetchCodingExercise
Coding exercise for Fetch Team. 

Hello Fetch Engineers and welcome to my coding exercise for your company!

You'll find all you need in the ContentView.swift file. 

I've set it up such that you'll press an (unstyled, I know) button up top, which will send the 
appropriate request and display the list filtered and sorted as you've asked! 

My interpretation of your requirements: 
1)  Display grouped by listID -> Sort by listID such that all entries with the same listID appear adjacent in list
2)  Sort first by listID then by name -> Once sorted by listID, break "ties" by name
  Note: Because the items are named after their item IDs, it is most efficient, in this case, to sort with item ID.
    This achieves the same grouping.
3) Names == "" or nil (I used Swift/iOS) are filtered out

As iOS 14 was just released outside of beta, I took the liberty to use iOS 14/Xcode 12 tools for this project - the newest.
If your systems are still using the previous version of Xcode and this doesn't build, let me know and I'll resubmit.

Finally, thank you for giving me the opportunity to complete these exercise and the chance to participate in Fetch's hiring process!
It's been a lot of fun so far!
