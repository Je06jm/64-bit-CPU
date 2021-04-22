from subprocess import run, DEVNULL

file = open("tests/list.txt", "r")
tests = file.readlines()
file.close()

def doCommand(cmd):
    #for item in cmd:
    #    print(item, end=" ")
    #print()

    run(cmd, stdout=DEVNULL)

failed = []
passed = 0
for test in tests:
    test = test.strip()

    if test.startswith("#"):
        continue

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

        if command.startswith("#"):
            continue

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
        name = testbench[:-3]
        path = "tests/" + test + "/"

        print("Running testbench: " + path + name + ".sv")

        cmd = [
            "iverilog",
            "-g2012",
            "-D",
            "DUMP_FILE=\"" + path + name + ".vcd\"",
            "-D",
            "PATH=\"" + path + "\"",
            "-o",
            path + name + ".out",
            path + testbench
        ] + required

        doCommand(cmd)

        cmd = [
            "vvp",
            "-l",
            path + name + ".log",
            path + name + ".out"
        ]

        doCommand(cmd)

        file = open(path + name + ".log", "r")
        lines = file.readlines()
        file.close()

        for line in lines:
            if line.startswith("Failed "):
                failed += [line.strip()]
            
            elif line.startswith("Passed "):
                passed += 1

print("Passed " + str(passed) + " test, Failed " + str(len(failed)) + " tests")
for test in failed:
    print("\t" + test)
