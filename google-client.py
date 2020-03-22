#!/bin/env python

from __future__ import print_function
import pickle
import os.path
import sys
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# Scope to read and write
# https://developers.google.com/identity/protocols/oauth2/scopes
SCOPES = ['https://www.googleapis.com/auth/documents']

#DOCUMENT_ID = '1VQ4lUr1hrrKQwOAYa2z0h-0xltBm1PEuQLY8VksWk7c'
DOCUMENT_ID = ''
DOCUMENT_INDEX = -1
DOCUMENT_TEXT = ''

def auth():
    creds = None
    # If the authentication has been performed already
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    service = build('docs', 'v1', credentials=creds)

    # Retrieve the documents contents from the Docs service.
    # document = service.documents().get(documentId=DOCUMENT_ID).execute()

    #print('The title of the document is: {}'.format(document.get('title')))
    return service


def insert(service):
   #https://developers.google.com/docs/api/how-tos/lists
    requests = [
         {
            'insertText': {
                'location': {
                    'index': DOCUMENT_INDEX,
                },
                'text': DOCUMENT_TEXT + '\n'
            }
         },
         {
            'createParagraphBullets': {
                'range': {
                    'startIndex': 1,
                    'endIndex':  2
                },
                'bulletPreset': 'NUMBERED_DECIMAL_ALPHA_ROMAN',
            }
         }
    ]

    result = service.documents().batchUpdate(
        documentId=DOCUMENT_ID, body={'requests': requests}).execute()


def _text():
  print("implement test")
if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('doc_id')
    parser.add_argument('doc_index')
    parser.add_argument('doc_text')
    args = parser.parse_args()

    DOCUMENT_ID = args.doc_id
    DOCUMENT_INDEX = args.doc_index
    DOCUMENT_TEXT = args.doc_text
    insert(auth())
