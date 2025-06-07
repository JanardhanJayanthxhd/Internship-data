"""
1.	Road Repair
A number of points along the highway are in need of repair. An equal number of crews are available, stationed at various
points along the highway. They must move along the highway to reach an assigned point. Given that one crew must be
assigned to each job, what is the minimum total amount of distance travelled by all crews before they can begin work?

For example, given crews at points {1,3,5} and required repairs at {3,5,7},
one possible minimum assignment would be {1→ 3, 3 → 5, 5 → 7} for a total of 6 units travelled.

Function Description
Develop a function getMinCost that returns the minimum possible total distance travelled as an integer.

getMinCost has the following parameter(s):
crew_points	:	a list of integers
repair_points	:	a list of integers

Constraints
Length of crew_points and repair_points should be the same

Sample Case 1
crew_points: [5,3,1,4,6]
repair_points: [9,8,3,15,1]

Explanation: The best possible assignment would be {1 → 1, 3 → 3, 4 → 8, 5 → 9, 6 → 15} and the distance will be 0+0+4+4+9.
Therefore, the answer is 17.

Sample Case 2
crew_points: [5,1,4,2]
repair_points: [4,7,9,10]

Explanation: The best possible assignment would be {1 → 4, 2 → 7, 4 → 9, 5 → 10} and the distance will be 3+5+5+5.
Therefore, the answer is 18.
"""


def get_min_distance(crew_points: list[int], repair_points: list[int]) -> int:
    """T: O(n log n), S: O(1)"""
    if len(crew_points) != len(repair_points):
        return -1

    result = 0
    crew_points.sort()
    repair_points.sort()

    for c, r in zip(crew_points, repair_points):
        result += abs(c - r)

    return result

c_p = [5,1,4,2]
r_p = [4,7,9,10]
print(get_min_distance(crew_points=c_p, repair_points=r_p))