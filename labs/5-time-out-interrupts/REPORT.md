Do you understand why we use values 1, 2 and 4 for the error codes, and not 1, 2 and 3?
Because timeout error is of different kind to NaD or overflow, and we want to make a distinction

Does it correspond to the current time of the Timer Tool window?
Yes it corresponds to the current number of seconds multiplied by 1000 (for minutes we have to multiply by 60000)