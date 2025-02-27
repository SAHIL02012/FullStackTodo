// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.27;
 
contract TaskContract {
     // Enum for task priority
    enum Priority { Low, Medium, High }
    struct Task {
        uint256 id;
        address username;
        string taskText;
        bool isDeleted;
        Priority priority; 
        
    }
 
    Task[] private tasks;
 
    // Mapping of Task id to the wallet address of the user
    mapping(uint256 => address) taskToOwner;
 
    event AddTask(address recipient, uint256 taskId);
    event DeleteTask(uint256 taskId, bool isDeleted);
 
    function addTask(string memory taskText, bool isDeleted,Priority priority) external {
        uint256 taskId = tasks.length;
        tasks.push(Task(taskId, msg.sender, taskText, isDeleted,priority));
        taskToOwner[taskId] = msg.sender;
        emit AddTask(msg.sender, taskId);
    }
 
    function getMyTasks() external view returns (Task[] memory) {
        Task[] memory temporary = new Task[](tasks.length);
        uint256 counter = 0;
        for (uint256 i = 0; i < tasks.length; i++) {
            if (taskToOwner[i] == msg.sender && tasks[i].isDeleted == false) {
                temporary[counter] = tasks[i];
                counter++;
            }
        }
 
        Task[] memory result = new Task[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }
 
    function deleteTask(uint256 taskId, bool isDeleted) external {
        if (taskToOwner[taskId] == msg.sender) {
            tasks[taskId].isDeleted = isDeleted;
            emit DeleteTask(taskId, isDeleted);
        }
    }
}