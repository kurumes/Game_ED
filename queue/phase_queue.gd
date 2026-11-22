extends Node
class_name PhaseQueue

const MAX = 4

var data: Array[Phase] = []
var front: int
var rear: int

func _init() -> void:
	front = -1
	rear = -1

func isEmpty() -> bool:
	return front == -1

func isFull() -> bool:
	return rear == MAX-1

func enqueue(hp: int, phase_id: int):
	if (isFull()):
		print("Full")
		return
	if (isEmpty()):
		front = 0
	
	rear += 1
	
	data.append(Phase.new(hp, phase_id))

func dequeue() -> Phase:
	if (isEmpty()):
		print("Empty")
		return null;
	
	var p: Phase = data[front]
	front += 1
	
	if (front > rear):
		front = -1
		rear = -1
	
	return p

func peek_hp() -> int:
	if (isEmpty()):
		print("Empty")
		return -1
	return data[front].hp
	
func peek() -> int:
	if (isEmpty()):
		print("Empty")
		return -1
	return data[front].phase_id

func printQueue() -> void:
	if (isEmpty()):
		print("Empty")
		return
	
	for i in range(front, rear+1):
		print("ID | ", data[i].phase_id)
		print("HP | ", data[i].hp)
