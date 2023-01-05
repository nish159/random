from typing import List
from random import randint

def generate_clip_path() -> str:
    number = randint(0, 60)
    points = []
    x = 0
    y = 0

    for i in range(number):
        # Alternate between x and y
        if i % 2:
            x = randint(0, 100)
        else:
            y = randint(0, 100)

        points.append(f"{x}% {y}%")

    return f"polygon({','.join(points)})"

clip_path = generate_clip_path()
print(clip_path)
