#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd


# In[3]:


data = pd.read_csv(r"C:\Users\DELL\Downloads\8. Netflix Dataset.csv")


# In[4]:


data


# In[5]:


data.head()


# In[6]:


data.tail()


# In[7]:


data.shape


# In[8]:


data.size


# In[9]:


data.columns


# In[10]:


data.dtypes


# In[11]:


data.info()


# In[12]:


# TASK 1: IS THERE ANY DUPLICATE RECORD IN THIS DATASET? IF YES, THEN REMOVE THE DUPLICATE RECORDS

data.head()


# In[13]:


data.shape


# In[17]:


data[data.duplicated()]


# In[19]:


data.drop_duplicates(inplace = True)


# In[20]:


data[data.duplicated()]


# In[21]:


data.shape


# In[22]:


# TASK 2: IS THERE ANY NULL VALUE PRESENT IN ANY COLUMN? SHOW WITH HEATMAP

data.head()


# In[23]:


data.isnull()


# In[25]:


data.isnull().sum()


# In[26]:


import seaborn as sns


# In[27]:


sns.heatmap(data.isnull())


# In[28]:


# Q1: FOR 'HOUSE OF CARDS', WHAT IS THE SHOW ID AND WHO IS THE DIRECTOR OF THIS SHOW?

data.head()


# In[31]:


data[data['Title'].isin(['House of Cards'])]


# In[33]:


data[data['Title'].str.contains('House of Cards')]


# In[34]:


# Q2: IN WHICH YEAR HIGHEST NUMBER OF THE TV SHOWS & MOVIES WERE RELEASED?SHOW IN BAR GRAPH.

data.dtypes


# In[36]:


data['Date_N'] = pd.to_datetime(data['Release_Date'])


# In[37]:


data.head()


# In[38]:


data.dtypes


# In[39]:


data['Date_N'].dt.year.value_counts()


# In[42]:


data['Date_N'].dt.year.value_counts().plot(kind='bar')


# In[43]:


# Q3: HOW MANY MOVIES AND TV SHOWSS ARE IN THE DATASET? SHOW WITH BAR GRAPH.

data.head(2)


# In[45]:


data.groupby('Category').Category.count()


# In[46]:


sns.countplot(data['Category'])


# In[47]:


# Q4: SHOW ALL THE MOVIES THAT WERE RELEASED IN YEAR 2020.

data.head(2)


# In[48]:


data['Year'] = data['Date_N'].dt.year


# In[49]:


data.head(2)


# In[50]:


data[(data['Category'] == 'Movie') & (data['Year'] ==2020)]


# In[51]:


# Q5: SHOW ONLY THE TITLES OF ALL TV SHOWS THAT WERE RELEASED IN INDIA ONLY.

data.head(2)


# In[60]:


data[ (data['Category']=='TV Show') & (data['Country'] =='India') ] ['Title']


# 

# In[61]:


# Q6: SHOW TOP 10 DIRECTORS, WHO GAVE THE HIGHEST NUMBER OF TV SHOWS AND MOVES TO NETFLIX?

data.head(2)


# In[63]:


data['Director'].value_counts().head(10)


# In[64]:


# Q7: SHOW ALL THE RECORDS, WHERE 'CATEGORY IS MOVIE AND TYPE IS COMEDIES' OR 'COUNTRY IS UNITED KINGDOM '.

data.head(2)


# In[68]:


data [(data['Category']=='Movie') & (data['Type']=='Comedies')] 


# In[69]:


data [(data['Category']=='Movie') & (data['Type']=='Comedies') | (data['Country']=='United Kingdom')]


# In[70]:


# Q8: IN HOW MANY MOVIES/SHOWS, TOM CRUISE WAS CAST?
data.head(2)


# In[72]:


data[data['Cast'] == 'Tom Cruise']


# In[74]:


data [data['Cast'].str.contains('Tom Cruise') ]


# In[75]:


data_new = data.dropna()


# In[76]:


data_new.head(2)


# In[77]:


data_new[data_new['Cast'].str.contains('Tom Cruise')]


# In[78]:


# Q9: WHAT ARE THE DIFFERENT RATING DEFINED BY NETFLIX?

data.head(2)


# In[79]:


data['Rating'].nunique()


# In[80]:


data['Rating'].unique()


# In[ ]:




