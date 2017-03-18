DATA DEMOGRAPHICS EXCHANGE (vl_api)
-----------------------------------

DESCRIPTION
-----------

Application built in Ruby on Rails (RoR) 
to be used for Data Exchange Demographics.

GETTING APPLICATION
-------------------

Get the application from github either by downloading it as a Zip file and extracting it 
or by cloning it into /var/www/

	By Clonning;

	https:
	
		https://github.com/BaobabHealthTrust/DDE2.git

	ssh:
	
		git@github.com:BaobabHealthTrust/DDE2.git

RUBY VERSION
------------

Ruby 2.2.2

	Verify that your Ruby Version Manager has ruby 2.2.2. activated for this application

Run

	bundle install

SYSTEM DEPENDENCIES
-------------------
	
CouchDB

	Make sure you have couchdb on the system as this application uses couchdb for Databases.

    To test for couchdb existence run the following command anywhere in terminal;
    
        curl http://127.0.0.1:5984/
        
    If output is as below then couchdb is installed and setup correctly;
        
        {"couchdb":"Welcome","uuid":"7f28e83989192dce8531276ee155f1be",
        "version":"1.6.0","vendor":{"name":"Ubuntu","version":"16.10"}}
        
CONFIGURATION
-------------

1. couchdb.yml
	
	In the config directory, configure the couchdb.yml by renaming or copying the couchdb.yml.example to couchdb.yml

	Set the database attributes as required for database connection.
	
	Major attributes that may require attention;
	
	    username, password, site_code
	    
	The site code should be the code for the site at which the application is being developed for.

		eg. MTA for Mtema	    

2. secrets.yml
		
	In the config directory, configure the secrets.yml by renaming or copying the secrets.yml.example to secrets.yml

DATABASE CREATION & INITIALIZATION
----------------------------------

Run the following command to create and initialize systems application;

    rake dde:setup
    
RUN APPLICATION !!!!
-------------------
Yeay...!!! We all Good. :-)