import pandas as pd
import re
import unicodedata
import os

def fuse():
    first = True
    dataFrame: pd.DataFrame
    dummy1: pd.DataFrame
    for x in os.listdir("captures/"):
        if x.endswith(".json"):
            if first:
                dummy1 = pd.read_json(f"captures/{x}")
                first = False
            else:
                dummy2 = pd.read_json(f"captures/{x}")
                dummy1 = pd.concat([dummy1, dummy2], axis=0)
    dataFrame = dummy1.reset_index(drop=True)

    return dataFrame
  
def clean_text(text: str):
    text = re.sub(r"\n", " ", text)
    text = re.sub(r"_+", "", text)
    text = re.sub(r"htt(ps|p):\/\/.+\/[^\s]{0,}", "", text)
    text = re.sub(r"(@|#)[\w\d-]+", "", text)
    text = re.sub(r"#", "", text)
    text = re.sub(r"\d", "", text)
    text = re.sub(r"\s+", " ", text)
    text = re.sub(r"[^\w\s]", "", text)

    text = ''.join(word for word in  unicodedata.normalize('NFC', text) if word <= '\uFFFF')

    text = text.lower()
    text = text.strip()

    return text
    
#Cleaning
data = fuse()

print(f'Raw: {data.__len__()}')

cleanFrame = data.drop_duplicates(subset=['Id'])
cleanFrame = data.reset_index(drop=True)

print(f'Clean: {cleanFrame.__len__()}')

value = data['RT'] == 'False'
cleanFrame = data[value]

print(f'Clean, no RT: {cleanFrame.__len__()}')

cleanFrame = cleanFrame.reset_index(drop=True)

print(f'Fused: {cleanFrame.__len__()}\n---------------------------------')

cleanFrame['Tweets'] = cleanFrame['Tweets'].apply(clean_text)
cleanFrame.to_json("clean/file.json")

cleanFrame = cleanFrame.drop_duplicates(subset=['Tweets'])
cleanFrame = cleanFrame.reset_index(drop=True)

cleanFrame.to_excel("clean/file.xlsx")
