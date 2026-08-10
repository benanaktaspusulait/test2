import sys
from time import localtime, strftime
from datetime import datetime

#############################################################################
# WARNING: This file is controlled via RepoSync, any changes made in the
# command adaptor repository will be overwritten by the RepoSync process.
# See https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################


# Checks to see if the current local hour is within working hours and returns a 1 if not.
def check_time():
    print(strftime("Localtime is %Y%M%dT%H%m"))
    hour = int(strftime("%H", localtime()))
    date = datetime.now()
    day = date.weekday()

    if day > 4:
        print("Error: Today is outside of working days!")
        print("Working days are from Monday - Friday.")
        return 1
    elif hour >= 18 or hour < 8:
        print(f"Error: {hour} is outside of working hours!")
        print("Working hours are from 08:00 to 18:00.")
        return 1
    else:
        return 0


sys.exit(check_time())
