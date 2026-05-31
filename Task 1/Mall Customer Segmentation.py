import pandas as pd
import numpy as np
from google.colab import files

print("--- Generating & Cleaning Mall Customer Data ---")
np.random.seed(44)
n = 1000

# Generating Data
names = ["Kabir", "Meera", "Ayaan", "Tara", "Rishi", "Zoya", "Dev", "Ananya", "Ishaan", "Diya", "Yash", "Shruti", "Samir", "Naina", "Varun"]
professions_20 = ["Engineer", "Doctor", "Artist", "Lawyer", "Teacher", "Chef", "Scientist", "Accountant", "Designer", "Writer", "Pilot", "Architect", "Consultant", "Nurse", "Pharmacist", "Photographer", "Actor", "Musician", "Entrepreneur", "Journalist", "Banker", "Developer"]

df = pd.DataFrame({
    'CustomerID': np.arange(1, n+1),
    'Name': np.random.choice(names, n),
    'Genre': np.random.choice(['Male', 'Female', 'Others'], n),
    'Age': np.random.randint(18, 70, n),
    'Annual Income (INR)': np.random.randint(400000, 5000000, n).astype(float),
    'Spending Score Amount (INR)': np.random.randint(1000, 150000, n),
    'Last Visit Date': pd.date_range(start='2023-01-01', periods=n, freq='D').strftime('%Y-%m-%d'),
    'Profession': np.random.choice(professions_20, n),
    'Items Purchased': np.random.randint(5, 150, n), 
    'Satisfaction Score': np.random.randint(1, 6, n)
})

# Inject dirty data
df.loc[5:25, 'Genre'] = 'Femal'
df.loc[200:250, 'Annual Income (INR)'] = np.nan
df_dirty = pd.concat([df, df.iloc[:40]], ignore_index=True)

# ==========================================
# INTERNSHIP TASK: DATA CLEANING OPERATIONS
# ==========================================
df_clean = df_dirty.copy()

# Step 5: Rename column headers to be clean and uniform (lowercase, no spaces)
df_clean.rename(columns={'Genre': 'Gender'}, inplace=True)
df_clean.columns = df_clean.columns.str.strip().str.lower().str.replace(' ', '_').str.replace(r'[^a-zA-Z0-9_]', '', regex=True)

# Step 1: Identify and handle missing values using .isnull()
if df_clean['annual_income_inr'].isnull().sum() > 0:
    income_median = df_clean['annual_income_inr'].median()
    df_clean['annual_income_inr'] = df_clean['annual_income_inr'].fillna(income_median)

# Step 2: Remove duplicate rows using .drop_duplicates()
df_clean = df_clean.drop_duplicates()

# Step 3: Standardize text values (Typo in Gender)
df_clean['gender'] = df_clean['gender'].replace({'Femal': 'Female'})

# Step 6: Check and fix data types (date as datetime, income as int)
df_clean['last_visit_date'] = pd.to_datetime(df_clean['last_visit_date'])
df_clean['annual_income_inr'] = df_clean['annual_income_inr'].astype(int)

# Step 4: Convert date formats to a consistent type (dd-mm-yyyy)
df_clean['last_visit_date'] = df_clean['last_visit_date'].dt.strftime('%d-%m-%Y')

# Display and Download
print(f"Final Shape: {df_clean.shape[0]} rows, {df_clean.shape[1]} columns")
filename = 'Mall_Customers_Cleaned.csv'
df_clean.to_csv(filename, index=False)
files.download(filename)