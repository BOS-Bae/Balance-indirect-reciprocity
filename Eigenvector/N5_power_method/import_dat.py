with open("N4_permute.dat", "r") as file:
    for line in file:
        elements = list(map(int, line.split()))
        
        # Now 'elements' contains the elements of the current line
        # You can process these elements as needed
        for element in elements:
            print(element, end=" ")
        print()

