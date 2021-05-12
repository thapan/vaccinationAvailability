#!/usr/bin/env python3

import json
import requests
from datetime import date
from playsound import playsound
import time

pincode = input("Pincode : ")  # your pincode or closet pincode near you
age_limit = input("Age : ")
timeinterval = int(input("Duration to refresh slots availability result (in minutes) : ")) # in minutes
timeinterval_Sec = timeinterval * 60

if 45 > int(age_limit) >= 18:
    age_limit = 18
elif int(age_limit) >= 45:
    age_limit = 45


if int(age_limit) < 18:
    print("Vaccination not open for age lesser than 18")
    exit
else:
    while True:

        today = date.today().strftime("%d-%m-%Y")
        url = 'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=' + pincode + '&date=' + today
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                          'Chrome/90.0.4430.93 Safari/537.36'}
        r = requests.get(url, headers=headers)
        data = r.content
        data_dict = json.loads(data)
        data = data_dict['centers']
        data_length = len(data)

        i = 0
        while i < data_length:
            data_df = data_dict['centers'][i]
            data_center_id = data_df['center_id']
            j = 0
            data_sessions = data_df['sessions']
            while j < len(data_sessions):
                data_sessions = data_df['sessions'][j]
                data_available_capacity = data_sessions['available_capacity']
                data_min_age_limit = data_sessions['min_age_limit']

                if data_available_capacity > 0 and data_min_age_limit == int(age_limit):
                    print("**********************************************")
                    print("Slots Available For Below Center")
                    print("Name of Center : " + data_df['name'])
                    print("Date : " + data_sessions['date'])
                    print("Capacity : " + str(data_sessions['available_capacity']))
                    print("Vaccine Name :" + data_sessions['vaccine'])
                    print("Time Slots : " + str(data_sessions['slots']))
                    print("**********************************************")
                    print("\n")
                    playsound('/Users/thapans/PycharmProjects/vaccineAvailabilityCheck/alertFile/alert.wav')
                j += 1
                if j >= len(data_df['sessions']):
                    break
            i += 1
            if i == data_length:
                break
        print("Will Search for slots again after " + str(timeinterval) + " Minute(s)")
        time.sleep(timeinterval_Sec)
        pass
