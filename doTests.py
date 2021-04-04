from subprocess import run

file = open("tests/list.txt", "r")
tests = file.readlines()
file.close()

for test in tests:
    test = test.strip()

    if len(test) == 0:
        continue

    commands = []

    try:
        file = open("tests/" + test + "/test.txt", "r")
        commands = file.readlines()
        file.close()

    except:
        print("Could not read tests/" + test + "/test.txt")

    testbenches = []
    required = []
    skip = False

    for command in commands:
        command = command.strip()

        if len(command) == 0:
            continue

        parts = command.split(":")

        for i in range(len(parts)):
            parts[i] = parts[i].strip()
        
        if parts[0] == "testbench":
            testbenches += [parts[1]]
        
        elif parts[0] == "required":
            required += [parts[1]]
        
        else:
            print("Unknown command: " + command)
            skip = True
            break
    
    if skip:
        continue

    for testbench in testbenches:
        output = testbench[:-3] + ".out"

        cmd = [
            "iverilog",
            "-g2012",
            "-o",
            "tests/" + test + "/" + output,
            "tests/" + test + "/" + testbench
        ] + required

        for item in cmd:
            print(item, end=" ")
        print()

        run(cmd)

