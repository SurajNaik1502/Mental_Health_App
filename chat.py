
# Ye Original Code hai 
# Executes sucessfully 


import os
from flask import Flask, render_template, jsonify, request
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import Pinecone as PineconeStore
#from langchain_pinecone import PineconeVectorStore
#import pinecone
from langchain.prompts import PromptTemplate
from pinecone import Pinecone
from langchain.llms import CTransformers
from langchain.chains import RetrievalQA
from dotenv import load_dotenv


app = Flask(__name__)

#download embedding model
def download_hugging_face_embeddings():
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
    return embeddings

# Get Pinecone API keys from environment variables
PINECONE_API_KEY = os.getenv("PINECONE_API_KEY")
PINECONE_API_ENV = os.getenv("PINECONE_API_ENV")

index_name="medical-chatbot"

pc = Pinecone(api_key=PINECONE_API_KEY)
embeddings = download_hugging_face_embeddings()
os.environ['PINECONE_API_KEY']= PINECONE_API_KEY
docsearch = PineconeStore.from_existing_index(index_name=index_name, embedding=embeddings)

prompt_template="""
Use the following pieces of information to answer the user's question.
If you don't know the answer, just say that you don't know, don't try to make up an answer.

Context: {context}
Question: {question}

Only return the helpful answer below and nothing else.
Helpful answer:
"""

PROMPT=PromptTemplate(template=prompt_template, input_variables=["context", "question"])

chain_type_kwargs={"prompt": PROMPT}

llm=CTransformers(model="model/llama-2-7b-chat.ggmlv3.q4_0.bin",
                  model_type="llama",
                  config={'max_new_tokens':512,
                          'temperature':0.8})


qa=RetrievalQA.from_chain_type(
    llm=llm, 
    chain_type="stuff", 
    retriever=docsearch.as_retriever(search_kwargs={'k': 2}),
    return_source_documents=True, 
    chain_type_kwargs=chain_type_kwargs)


@app.route("/")
def index():
    return render_template('chat.html')



@app.route("/get", methods=["GET", "POST"])
def chat():
    msg = request.form["msg"]
    input = msg
    print(input)
    result=qa({"query": input})
    print("Response : ", result["result"])
    return str(result["result"])



if __name__ == '__main__':
    app.run(host="0.0.0.0", port= 5050, debug= True)


