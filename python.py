import sqlite3
import time
import os
import getpass
import prints
import re
from datetime import datetime, timedelta
import sys


connection = None
cursor = None

# User id after login
usr_id = None
# if user is replying to someone, the user id of the person who is receiving the reply
reply_id = None


def connect(filename: str):
    """
    Connects to a SQLite database using the provided filename and enables foreign key constraints
    :param filename: The name of the SQLite database file to connect to.
    :return: None
    """
    global connection, cursor

    connection = sqlite3.connect(filename)  # creates a database
    cursor = connection.cursor()  # creates a cursor, we need this for executing SQL commands
    cursor.execute(' PRAGMA foreign_k1eys=ON; ')  # foreign key constraint
    connection.commit()
    return


def first_screen():
    """
    First screen of the app.
    The user is displayed a screen that allows them to log in, register or quit the app.
    :return:
    """
    prints.printSignin()
    run = True
    while run:
        print("1. Login")
        print("2. Register")
        print("3. Exit")
        try:
            choice = int(input("Enter your choice: "))
            assert 1 <= choice <= 3
            run = False
        except:
            print("Invalid choice\n")
            continue
    clear_screen()
    return choice


def second_screen():
    """
    This function is responsible for displaying the home screen.
    The home screen displays the tweets and retweets by the followers of the user.
    The home screen also has options to search for tweets, search for users, compose a tweet, list followers and logout.
    :return: int: choice of the user based on which the next function is performed.
    """
    global connection, cursor, usr_id
    # this query is simply being used to get the username to write a welcome message in homescreen
    cursor.execute('SELECT name FROM users WHERE usr = ?;', (usr_id,))
    user_name = cursor.fetchone()[0]
    run = True
    index = 0
    while run:
        prints.printHome()
        # this is the welcome message
        print(f"Hello {user_name}, nice to have you back!\n")
        print(f"You have the user number: {usr_id}\n")
        tweet_rows = get_follower_tweets(usr_id)
        print_table(tweet_rows[index:min(index + 5, len(tweet_rows))], ["Tweet #", "Name", "Tweet", "Tweet Date", "Retweeted By", "Retweet Date"])
        select_tweet_options = [chr(i) for i in range(65, 91)][:min(index + 5, len(tweet_rows))-index]
        print("SELECT TWEET: ", select_tweet_options)
        print("\n")
        print("1. Search Tweets")
        print("2. Search for Users")
        print("3. Compose a Tweet")
        print("4. List Followers")
        print("5. Logout")
        print("         To scroll home tweets")
        print("         <<<6             7>>>")
        try:
            choice = input("Enter your choice: ")
            assert choice in ['1', '2', '3', '4', '5', '6', '7'] or choice in select_tweet_options
            run = False
        except:
            print("Invalid choice\n")
            clear_screen()
            continue
        if choice not in select_tweet_options:
            choice = int(choice)
        else:
            char_to_number = {char: ord(char) - 64 for char in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'}
            choice_mapped = char_to_number[choice] - 1
            clear_screen()
            return choice, tweet_rows[index:min(index + 5, len(tweet_rows))][choice_mapped]
        if choice == 6:
            run = True
            if index == 0:
                print("INVALID: Can't go left...")
                time.sleep(1)
            else:
                index -= 5
            clear_screen()
            continue
        if choice == 7:
            run = True
            if index+5 > len(tweet_rows):
                print("INVALID: Can't go right...")
                time.sleep(1)
            else:
                index += 5
            clear_screen()
            continue

    clear_screen()
    return choice, None

def login():
    """
    User login function.
    Lets a new user register a new account or an existing user to log in to their existing account
    This function also checks for sql injection attacks
    :return: None
    """
    global connection, cursor, usr_id
    prints.printLogin()
    login = True
    while login:
        print("If you wish to go back to the main screen, enter .exit as your username \n")
        usr = input("Enter username: ")
        if usr == ".exit":
            clear_screen()
            return 4
        pwd = getpass.getpass(prompt="Enter password: ")
        cursor.execute('SELECT * FROM users WHERE name = ? COLLATE NOCASE AND pwd = ?;', (usr, pwd))
        login_value = cursor.fetchone()
        if login_value is not None:
            print("Login successful")
            clear_screen()
            usr_id = login_value[0]
            return
        else:
            print("Login failed")
    return

#TO DO: ask the user to confirm all the details hes entered
def register():
    global connection, cursor
    prints.printRegister()
    while True:
        while True:
            try:
                special = ["-", "'", " "]
                name = input("Enter your name: ")
                split_name = name.split()
                assert len(split_name) >= 1
                for i in split_name:
                    for j in i:
                        assert j.isalpha() or j in special
                break
            except:
                print("Registration failed because invalid input was entered \n")

        while True:
            try:
                email = input("Enter your email: ")
                dot_idx = email.index(".")
                at_idx = email.index("@")
                assert "@" in email and "." in email 
                assert (email[at_idx+1].isalpha())
                assert (email[dot_idx-1].isalpha())
                assert (len(email[:at_idx]) >= 1 and len(email[at_idx+1:dot_idx]) >= 2)
                assert (len(email[dot_idx+1:]) > 1 and len(email[dot_idx+1:]) < 4)
                break
            except:
                print("Registration failed because invalid input was entered \n ")

        while True:
            try:
                city = input("Enter your city: ")
                city_split = city.split()
                for i in city_split:
                    assert i.isalpha()
                break
            except:
                print("Registration failed because invalid input was entered \n")

        while True:
            try:
                timezone = float(input("Enter your timezone: "))
                assert -12 <= timezone <= 12
                break
            except:
                print("Registration failed because invalid input was entered \n")

        while True:
            try:
                password = getpass.getpass(prompt="Enter password: ")
                assert len(password) >= 6
                break
            except:
                print("Registration failed because invalid input was entered\n")

        print("\nPlease confirm your details: ")
        print("Name:", name)
        print("Email:", email)
        print("City:", city)
        print("Timezone:", timezone)
        check = input("Are these details correct? (y/n): ")
        if check == "y":
            break
        
    cursor.execute("SELECT usr FROM users")
    rows = cursor.fetchall()
    unique_usr = rows[-1][0] + 1
    cursor.execute("INSERT INTO users VALUES (?, ?, ?, ?, ?, ?);", (unique_usr, password, name, email, city, timezone))
    print("Registration successful")
    connection.commit()
    print("Your username is: ", unique_usr)
    clear_screen()

    return


def compose_tweet():
    """
    This function is used to compose a new tweet or reply to a tweet.
    The user can write a tweet which can include hashtags which are stored in a separate database.
    :return: None
    """
    global connection, cursor, usr_id, reply_id
    prints.printCompose()

    tweet = input("Type down your tweet: ")
    hashtags = re.findall(r'#(\w+)', tweet)
    usr_time = get_time()

    cursor.execute("SELECT * FROM tweets")
    rows = cursor.fetchall()
    if len(rows) == 0:
        unique_tweet = 1
    else:
        unique_tweet = rows[-1][0] + 1
    # print((unique_tweet, usr_id, usr_time, tweet, reply_id))
    cursor.execute("INSERT INTO tweets VALUES (?, ?, ?, ?, ?);", (unique_tweet, usr_id, usr_time, tweet, reply_id))
    connection.commit()

    cursor.execute("SELECT term FROM hashtags")
    all_hashtags = [i[0] for i in cursor.fetchall()]

    if len(hashtags):
        for i in hashtags:
            if i not in all_hashtags:
                cursor.execute("INSERT INTO hashtags VALUES (?)", (i,))
                connection.commit()
            cursor.execute("INSERT INTO mentions VALUES (?, ?)", (unique_tweet, i))
            connection.commit()
    print("\n\nTweeted Successfully!")
    reply_id = None
    clear_screen()

    return


def listFollowers():
    """
    List the followers of the users.
    Give details about the user's followers including tweets count, followed and followers of the user's followers.
    The user can view their followers tweets and also follow them back.
    :return: None
    """
    global connection, cursor, usr_id, reply_id

    cursor.execute("SELECT name, flwer, start_date FROM follows, users WHERE flwee = (?) and follows.flwer = users.usr ORDER BY name", (usr_id,))
    rows = cursor.fetchall()
    followers = [str(i[1]) for i in rows]
    followers.append('q')

    viewing_user = False
    while True:
        if not viewing_user:
            prints.printListFollowers()
            cursor.execute("SELECT name, flwer, start_date FROM follows, users WHERE flwee = (?) and follows.flwer = users.usr ORDER BY name", (usr_id,))
            rows = cursor.fetchall()
            print_table(rows, ["Name", "Followers", "Follow Date"])
            user_choice = ""
            try:
                user_choice = input("Enter the user id to view more details (Enter 'q' to go to homepage): ")
                viewing_user = True
                assert user_choice in followers
            except:
                print("User not found in followers. Try again... \n")
                viewing_user = False
                clear_screen()
                continue
            if user_choice == 'q':
                break
            else:
                user_choice = int(user_choice)
                rows = get_tweets_flwer_flwee(user_choice)
                print_table(rows, ['Tweets', 'Followed', 'Followers'])
                cursor.execute("SELECT text, tdate FROM tweets WHERE writer = (?) ORDER BY tdate DESC", (user_choice,))
                print("\n\n")
                rows = cursor.fetchall()
                if len(rows) >= 3:
                    print_table(rows[:3], ['Tweet', 'Date'])
                else:
                    print_table(rows, ['Tweet', 'Date'])
        if viewing_user:
            print("\n\n")
            print("1. View more tweets")
            print("2. Follow User")
            print("3. Go back")
            try:
                user_choice_2 = int(input("Enter your choice: "))
                assert 1 <= user_choice_2 <= 3
            except:
                print("Invalid choice. Try again... \n")

            if user_choice_2 == 1:
                print_table(rows, ['Tweet', 'Date'])
            elif user_choice_2 == 2:
                follow_user(usr_id, user_choice)
                continue
            elif user_choice_2 == 3:
                viewing_user = False
                clear_screen()
                continue

    clear_screen()
    return


def tweet_overview(tweet_id):
    """
    This function gives an overview of a tweet.
    The overview includes tweet stats such as # of retweets and # of replies
    The user can also retweet a tweet or reply to a tweet using this function
    :param tweet_id: id number of the tweet
    :return: None
    """
    global reply_id
    prints.printViewTweet()
    tweet_stats = get_tweet_info(tweet_id)
    print_table(tweet_stats, ['Tweet ID', 'Tweet', 'Retweets', 'Replies'])
    while True:
        print("\n\n")
        print("1. Reply to tweet")
        print("2. Retweet")
        print("3. Go back")
        try:
            user_choice = int(input("Enter your choice: "))
            assert 1 <= user_choice <= 3
        except:
            print("Invalid choice. Try again... \n")

        if user_choice == 1:
            reply_id = tweet_id
            compose_tweet()
            break
        elif user_choice == 2:
            retweet_tweet(tweet_id)
            clear_screen()
            break
        elif user_choice == 3:
            clear_screen()
            break
    return


############################ Helper Functions ###################################
def retweet_tweet(tweet_id):
    global cursor, connection, usr_id
    cursor.execute("SELECT * FROM retweets WHERE usr = (?) AND tid = (?);", (usr_id, tweet_id))
    rows = cursor.fetchall()
    if len(rows):
        print("Tweet has been already retweeted...")
    else:
        cursor.execute("INSERT INTO retweets VALUES (?, ?, ?);", (usr_id, tweet_id, get_time()))
        connection.commit()
        print("Tweet has been retweeted successfully")
    return


def get_follower_tweets(id):
    """
    Gets the tweets and retweets of the accounts that the user follows
    :param id: int: user id
    :return: tuple containing name, tweet text, tweet date, retweet user, retweet date
    """
    global cursor, connection, usr_id
    cursor.execute("""
    SELECT 
    tweets.tid,
    users.name, 
    tweets.text, 
    tweets.tdate, 
    COALESCE(retweets.usr, '') AS retweet_usr,
    COALESCE(retweets.rdate, '') AS retweet_date
    FROM 
        tweets
    JOIN 
        users ON tweets.writer = users.usr
    LEFT JOIN 
        retweets ON tweets.tid = retweets.tid
    WHERE 
        tweets.writer IN (SELECT flwee FROM follows WHERE flwer = (?))
        OR
        retweets.usr in (SELECT flwee FROM follows WHERE flwer = (?))
    ORDER BY 
        COALESCE(retweets.rdate, tweets.tdate) DESC;
""", (id, id))
    return cursor.fetchall()


def follow_user(flwer, flwee):
    """
    Creates an entry in the follows table such that the flwer follows the flwee
    :param flwer: user id of the follower
    :param flwee: user id of the followee
    :return: None
    """
    global cursor, connection, usr_id
    cursor.execute("SELECT flwee FROM follows WHERE flwer = (?);", (flwer,))
    rows = cursor.fetchall()
    user_follows = [i[0] for i in rows]
    if flwee in user_follows:
        print("User is already followed...")
    else:
        cursor.execute("INSERT INTO follows VALUES (?, ?, ?);", (flwer, flwee, get_time()))
        connection.commit()
        print("User is followed successfully...")
    return


def get_tweets_flwer_flwee(id):
    """
    Provides information of a user.
    This includes # of tweets, # of followers and # of account followed.
    :param id: user id
    :return: list of a single tuple which contains tweets, flwer and flwee
    """
    global cursor, connection, usr_id
    cursor.execute("SELECT count(*) FROM tweets WHERE writer = (?)", (id,))
    tweets = cursor.fetchone()[0]
    cursor.execute("SELECT count(*) FROM follows WHERE flwer = (?)", (id,))
    flwer = cursor.fetchone()[0]
    cursor.execute("SELECT count(*) FROM follows WHERE flwee = (?)", (id,))
    flwee = cursor.fetchone()[0]
    rows = [(tweets, flwer, flwee)]
    return rows


def clear_screen():
    """
    Clears the screen with a pause of 0.5 seconds
    :return: None
    """
    time.sleep(0.5)
    if os.name == 'nt':  # Windows
        os.system('cls')
    else:  # macOS and Linux
        os.system('clear')


def get_time():
    """
    Gets the time of the active user incorporating the user's timezone.
    :return: DateTime
    """
    global cursor, connection, usr_id
    cursor.execute("SELECT timezone FROM users where usr = ?", (usr_id,))
    timezone = cursor.fetchone()[0]
    current_time = datetime.now()
    timezone_delta = timedelta(hours=timezone)
    new_time = current_time + timezone_delta
    return new_time


def print_table(rows, headers=None):
    """
    Displays the information provided in a tabular format.
    :param rows: Tuple of tuples that contains information to be displayed, usually a query output
    :param headers: List of strings that are headers for the table
    :return: None
    """
    if not rows:
        print("No rows to display.")
        return

    # Determine the maximum width for each column
    temp_rows = list(rows)
    temp_rows.append(headers)
    max_width = [max(len(str(row[i])) for row in temp_rows) for i in range(len(temp_rows[0]))]

    # Create a format string for each column based on the maximum width
    format_str = "|".join(f" {{:<{width}}} " for width in max_width)

    # Determine the separator line
    separator = "-".join("-" * (width + len(rows[0])) for width in max_width)

    # Print the table headers
    if headers:
        header_str = format_str.format(*headers)
        print(separator)
        print(f"| {header_str} |")
        print(separator)

    # Print the rows
    for row in rows:
        row_str = format_str.format(*row)
        print(f"| {row_str} |")

    print(separator)


def get_tweet_info(tweet_id):
    global cursor, connection, usr_id
    cursor.execute("""
    SELECT 
    t.tid AS tweet_id,
    t.text,
    COALESCE(COUNT(DISTINCT r.usr), 0) AS num_retweets,
    COALESCE(COUNT(DISTINCT tr.tid), 0) AS num_replies
    FROM 
        tweets t
    LEFT JOIN 
        retweets r ON t.tid = r.tid
    LEFT JOIN 
        tweets tr ON t.tid = tr.replyto
    WHERE 
    t.tid = (?);""", (tweet_id,))
    return cursor.fetchall()

# TODO: Add more comments to this function
# TODO: put this function in its own file and make a config.py file with global
# variables.
def search_tweet():
    """
    Searches for tweets in the database using any number of keywords and
    displays tweets that match at least one keyword or if the keyword starts
    with '#' then it searches for the mentions table instead.
    (search is case-insensitive)
    :param: None
    :return: None
    """
    # Prints the title of the screen
    prints.printSearchTweets()

    # Get user input
    keywords_input = input("Enter keywords to search for tweets: ")
    keywords = keywords_input.split()
    tweets_set = set()

    for keyword in keywords:
        if keyword[0] == '#':  # When Keyword starts with '#'
            keyword = keyword[1:]  
            cursor.execute('''
                           SELECT tid, tweets.text, tdate
                           FROM tweets
                           WHERE tid in (
                                        SELECT tid
                                        FROM mentions
                                        WHERE lower(term) = lower(:keyword)
                                        )
                           ''', {"keyword":keyword})
        else:  # When Keyword doesnt start with '#'
            cursor.execute('''
                           SELECT tid, tweets.text, tdate
                           FROM tweets
                           WHERE INSTR(lower(text), lower(:keyword))
                           ''', {"keyword":keyword})
        # Used set to ignore dublicate tweets
        tweets_set = tweets_set.union(set(cursor.fetchall()))
    # Convert to list to sort it, since set is unordered
    tweets_list = list(tweets_set)

    # Sorting tweets:
    # Format the tweet date to 1 format for sorting
    i = 0
    for tweet in tweets_list:
        tweet = list(tweet)
        if len(tweet[2]) == 10:
            # If date only add time with milliseconds
            tweet[2] += " 00:00:00.0"
        elif len(tweet[2]) == 19:
            # If date and time w/o milliseconds add milliseconds
            tweet[2] += ".0"
        tweets_list[i] = tweet
        i+=1
    tweets_list = sorted(tweets_list, key=lambda x: (datetime.strptime(x[2], '%Y-%m-%d %H:%M:%S.%f')))

    # Displaying the tweets
    run = True
    index = 0
    while run:
        clear_screen()
        prints.printSearchTweets()
        print_table(tweets_list[index:min(index + 5, len(tweets_list))], ["Tweet #", "Name", "Tweet Date"])
        select_tweet_options = [chr(i) for i in range(65, 91)][:min(index + 5, len(tweets_list))-index]
        print("SELECT TWEET: ", select_tweet_options)
        print("\n")
        print("1. Exit")
        print("         To scroll tweets")
        print("         <<<2        3>>>")
        try:
            choice = input("Enter your choice: ")
            assert choice in select_tweet_options or choice in ['1','2','3']
            #run = False
        except:
            print("Invalid choice\n")
            clear_screen()
            continue
        if choice not in select_tweet_options:
            choice = int(choice)
            if choice == 1:
                clear_screen()
                return
            elif choice == 2:
                run = True
                if index == 0:
                    print("INVALID: Can't go left...")
                    #time.sleep(1)
                else:
                    index -= 5
                clear_screen()
                continue
            elif choice == 3:
                run = True
                if index+5 > len(tweets_list):
                    print("INVALID: Can't go right...")
                    #time.sleep(1)
                else:
                    index += 5
                clear_screen()
                continue
        else:
            # Selecting the tweet
            char_to_number = {char: ord(char) - 64 for char in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'}
            choice_mapped = char_to_number[choice] - 1
            chosen_tweet = tweets_list[index:min(index + 5, len(tweets_list))][choice_mapped]

            clear_screen()
            tweet_overview(chosen_tweet[0])


def search_users():
    """
    This function allows a user to search for other users in a database by a keyword.
    The search is performed first by matching the keyword with the user's name, then
    by the city. Results are paginated and the user can navigate through pages,
    view more results, or quit the search.
    """
    prints.printSearchUsers()
    # Step 1: Take a search keyword as input
    keyword = input("Enter a keyword to search for users: ").strip()
    
    # To keep track of the current page of results
    page_size = 5
    current_index = 0
    while True:
        # Calculate the range of results to display for pagination
        
        
        # Step 2: Query the database to find users
        # Users whose name matches the keyword
        cursor.execute("""
            SELECT usr, name, city
            FROM users
            WHERE name LIKE ?
            ORDER BY LENGTH(name), name
        """, ('%' + keyword + '%',))
        name_matches = cursor.fetchall()
        
        # Users whose city matches the keyword but name does not
        cursor.execute("""
            SELECT usr, name, city
            FROM users
            WHERE city LIKE ? AND name NOT LIKE ?
            ORDER BY LENGTH(city), city
        """, ('%' + keyword + '%', '%' + keyword ,))
        city_matches = cursor.fetchall()
        
        # Combine and sort the results
        results = name_matches + city_matches
        #results.sort(key=lambda x: (len(x[1]) if keyword.lower() in x[1].lower() else len(x[2]), x[1]))
        
        # Step 3: Display results
        if not results:
            print("No matching users found.")
            clear_screen()
            break
            
        print("\nSearch results:")

        for i, (usr, name, city) in enumerate(results[current_index:current_index + page_size], start=1):
            print(f"{i+current_index}. {name} (City: {city})")
        
        # Step 4: Provide options to view more results or exit
        user_choice = input("\nEnter a number to view user details (1-5), 'm' to view more results, or 'q' to quit: ").strip().lower()
        if user_choice == 'm':
            current_index += page_size
        elif user_choice == 'q':
            clear_screen()
            break
        elif user_choice.isdigit() and 1 <= int(user_choice) <= 5:
            # View user details
            user_choice = int(user_choice) + current_index
            if user_choice <= len(results):
                selected_user = results[int(user_choice) - 1]
                view_user_details(selected_user[0])
            else:
                print("Invalid input. Please enter a valid option.")
        else:
            print("Invalid input. Please enter a valid option.")


def view_user_details(user_id):
    """
    This function retrieves and displays details for a specific user identified by their user ID.
    It shows the user's name, email, city, timezone, number of followers, number of users they are following,
    and the number of tweets they have made. It also lists the user's most recent tweets.
    After displaying the details, it offers the user options to follow this user,
    view more tweets, or return to the previous menu.
    
    Parameters:
    user_id (str): The unique identifier of the user whose details are to be viewed.
    """
    
    # Query the database to get user details
    cursor.execute("""
        SELECT 
            u.usr, 
            u.name, 
            u.email, 
            u.city, 
            u.timezone, 
            COUNT(DISTINCT f1.flwer) AS followers,  
            COUNT(DISTINCT f2.flwee) AS following   
        FROM 
            users u
            LEFT JOIN follows f1 ON u.usr = f1.flwee  
            LEFT JOIN follows f2 ON u.usr = f2.flwer  
        WHERE 
            u.usr = ?
        GROUP BY 
            u.usr
    """, (user_id,))
    user = cursor.fetchone()
    
    # Fetch the number of tweets the user has
    cursor.execute("""
        SELECT COUNT(*)
        FROM tweets
        WHERE writer = ?
    """, (user_id,))
    tweet_count = cursor.fetchone()[0]
    
    if user:
        usr, name, email, city, timezone, followers, following = user
        print(f"\nUser Details for {name}:")
        print(f"Email: {email}")
        print(f"City: {city}")
        print(f"Timezone: {timezone}")
        print(f"Followers: {followers}")
        print(f"Following: {following}")
        print(f"Number of Tweets: {tweet_count}")
        
        # Query to get the most recent tweets
        cursor.execute("""
            SELECT text
            FROM tweets
            WHERE writer = ?
            ORDER BY tdate DESC
            LIMIT 3
        """, (usr,))
        tweets = cursor.fetchall()
        
        print("\nMost Recent Tweets:")
        for i, (tweet,) in enumerate(tweets, start=1):
            print(f"{i}. {tweet}")
    else:
        print("User not found.")
    
    
    # Provide options to follow the user or view more tweets
    while True:
        user_choice = input("\nEnter 'f' to follow this user, 't' to view more tweets, or 'q' to go back: ").strip().lower()

        if user_choice == 'f':
            follow_user(user_id, usr)  # Placeholder for follow functionality
            break
        elif user_choice == 't':
            view_more_tweets(user_id)  # Placeholder for view more tweets functionality
            break
        elif user_choice == 'q':
            print('Gone back!')
            clear_screen()
            break
        else:
            print('Invalid input, please try again.')



def view_more_tweets(user_id):
    """
    Function to view more tweets from a user. Displays up to 'limit' tweets.
    """
    # Query to get more tweets from the user, limited by the 'limit' parameter
    cursor.execute("""
        SELECT text, tdate
        FROM tweets
        WHERE writer = ?
        ORDER BY tdate DESC
    """, (user_id,))
    tweets = cursor.fetchall()
    
    # Display the tweets
    if tweets:
        print(f"\nMore Tweets from user {user_id}:")
        for tweet, date in tweets:
            print(f"- {date}: {tweet}")
    else:
        print("No more tweets found.")


def main():
    global connection, cursor, usr_id

    path = "./minip.db"  # change the db name if you want
    connect(path)
    clear_screen()
    while True:
        if not usr_id:
            choice = first_screen()
            if choice == 1:  # login
                if login() == 4:
                    continue
            elif choice == 2:  # sign-up
                register()
                print("Please login to continue")
                login()
            elif choice == 3:  # exit
                print("Thank you for using Mini Project")
                break
        choice, _ = second_screen()
        if _:
            tweet_overview(_[0])
            clear_screen()
            continue
        if choice == 1:
            search_tweet()
        elif choice == 2:
            search_users()
        elif choice == 3:
            compose_tweet()
        elif choice == 4:
            listFollowers()
        elif choice == 5:
            usr_id = None
            print("User have been logged out.")
            print("Returning to Home Screen...")
            clear_screen()
            continue

    connection.commit()
    connection.close()
    return


if __name__ == "__main__":
    main()
