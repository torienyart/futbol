[Turing School](https://turing.edu/) is an industry leading, online computer programming school, focused solely on helping students launch fulfilling careers in technology.

In week five of Mod 1 we are assigned a multiday group project named Futbol. Listed below are our specifications and outcomes of the project. 

## Learning Goals

* Build classes with single responsibilities.
* Write organized readable code.
* Use TDD as a design strategy.
* Design an Object Oriented Solution to a problem.
* Practice algorithmic thinking.
* Work in a group.
* Use Pull Requests to collaborate among multiple partners.

## About

We will be using data from a fictional soccer league to analyze team performance for specific seasons and across seasons. We want to see who the best and worst performers are, as well as be able to pull statistics for individual teams.

## Built With

Ruby 2.7.2 and RSpec 3.12 versions.

## Testing

A key goal of this project is to utilize Test Driven Development. Since the data set is so large, it was inefficient to use the actual dataset as our test data. Instead, we made up own test data by creating fixture CSV files.

## Authors 

[Tori Enyart](https://github.com/torienyart) ,
[Bobby Luly](https://github.com/Bobsters986) ,
[Elle Majors](https://github.com/Elle-M), [Weston Sandfort](https://github.com/sandfortw)

## Q&A

*As a group, discuss and write your answers to the following questions. Include your responses as a section in your project README.*

*What was the most challenging aspect of this project?*

  * Figuring out how to navigate the git workflow as a group

*What was the most exciting aspect of this project?*

  * Finally getting to refactor and having that go successfully w/ few bugs.

*Describe the best choice enumerables you used in your project. Please include file names and line numbers.*

 * We enjoyed using the .count method in the helper methods #home_wins(Ln 7), #away_wins(Ln 11), and #tie_games(Ln 15) in the helper_methods.rb file.       It was an easy way to count up the number of times a game result was determined in each way.
 * The .sort_by enumerable came in handy many times when sorting a hash by it’s values in our various helper_methods.rb(Lns 43, 60, 146, 182).             season_stats.rb(Lns 6, 10, 14, 22, 30, 37)
 * .find_all was great for finding all games or game_teams that met our criteria helper_methods.rb(Lns 88, 102, 160)
* .find season_stats.rb(Lns 15, 23), helper_methods.rb(Ln 122)

*Tell us about a module or superclass which helped you re-use code across repository classes. Why did you choose to use a superclass and/or a module?*

 * The Helpable module we created was particularly useful. It housed all of the helper methods that we had created throughout the project. We used this     module across all of our other modules which were broken up according to what data they were in charge of.
  
*Tell us about 1) a unit test and 2) an integration test that you are particularly proud of. Please include file name(s) and line number(s).*

  * We are proud of the simplicity of our tests. The helper methods are stored in their own section, which avoids repeating code. A good example of this    is #winningest_coach/#worst_coach on line 189 in the spec. This function relies on #coaches_win_percentage_hash(season) and                        #array_of_game_teams_by_season(season), which are tested on lines 318 and 313 respectively.
  
*Is there anything else you would like instructors to know?*

* Nothing comes to mind.

*As individuals:*

*Please include a minimum of 1 question from each group member (max: 3 questions per group member)questions as a Your evaluating instructor will answer these in your feedback video.*

* Bobby- What is preferred more in the back end development world, the use of multiple modules or inheritance among classes? I can see the utility in both, but I wonder what’s the most efficient or if theres an industry preference?

* Tori - We recognized that our DataFactory class doesn’t really need to be a superclass and probably makes more sense in terms of encapsulation principles to not be a parent class. However, in order to pass the spec_harness it needed to be a superclass because the spec_harness calls for StatTracker.from_csv instead of DataFactory.from_csv

* Elle - Are there any disadvantages to using modules the way we have in our project?

* Weston- Would it be better to integrate the helper method tests within the tests for the main methods?



