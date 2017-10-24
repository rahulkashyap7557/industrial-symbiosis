# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

Contains the code used for the study of Industrial Ecosystems. The code takes a seed of an ecosystem and evolves it. 
An algorithm has been created to set up rules for network evolution. The focus is on when and how industrial networks die out.
Networks are evolved using a discrete time scheme. Dead networks are identified and their history is extracted.   
Then this data is cleaned up, processed, analyzed and the results are interpreted. 
We find that the networks participating in industrial symbiosis are less prone to network failure.
The details of the study and the model are present in the the paper http://www.mdpi.com/2071-1050/9/4/605

### How do I get set up? ###

Download the code and run the file lifeAndDeath.m to run the simulation. 
To extract the cleaned up data for the dead networks run sortDeadNetworks.m.
Finally for data analysis, run dataAnalysis.m.
For data analysis, please note that you need to add your own custom metrics for the data. 

### Who do I talk to? ###

Rahul Kashyap (for model, data analysis and code related issues)
Email me at rahulkashyap7557@gmail.com
* Other community or team contact
Shauhrat S. Chopra (for model and data analysis related issues)
Email him at chopra420@gmail.com