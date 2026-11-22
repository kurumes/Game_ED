extends Node2D

var queue: PhaseQueue

func _ready()-> void:
	queue = PhaseQueue.new()
	
	queue.enqueue(940, 1)
	queue.enqueue(590, 2)
	queue.enqueue(350, 3)
	queue.enqueue(120, 4)
	
	queue.printQueue()
	
	print("")
	print("Full: ",queue.isFull())
	print("")
	print("Peek: ", queue.peek())
	
	var removed: Phase = queue.dequeue()
	print("")
	print("Removed HP|ID")
	print(removed.hp, "|", removed.phase_id)
	
	queue.printQueue()
	
	print("")
	print("Remaining: ", queue.rear, "|", queue.front+1)
	
	while not queue.isEmpty():
		var p: Phase = queue.dequeue()
		print("Removed: ", p.phase_id)
	
	print("Empty: ", queue.isEmpty())
	
	var r = queue.dequeue()
	print("Dequeueing when empty: ",r)
