# Prompt User for Password:

while True:
    user_input_one = input(
        "Please enter a database password you would like to use: ")
    user_input_two = input("Please re-enter the database password.")

    if user_input_one == user_input_two:
        print('Passwords match, setting password on AWS...')
        break
    else:
        print('Passwords do not match!')
