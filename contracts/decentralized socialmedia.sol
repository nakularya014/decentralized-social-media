// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Project {
    struct Post {
        uint256 id;
        address author;
        string content;
        string imageHash; // IPFS hash for images
        uint256 timestamp;
        uint256 likes;
        bool isActive;
    }

    struct User {
        string username;
        string bio;
        string profileImageHash; // IPFS hash
        uint256 postCount;
        uint256 followerCount;
        uint256 followingCount;
        bool isRegistered;
    }

    // State variables
    mapping(address => User) public users;
    mapping(uint256 => Post) public posts;
    mapping(address => mapping(address => bool)) public following;
    mapping(uint256 => mapping(address => bool)) public postLikes;
    mapping(address => uint256[]) public userPosts;
    
    uint256 public postCounter;
    uint256 public userCounter;
    
    // Events
    event UserRegistered(address indexed userAddress, string username);
    event PostCreated(uint256 indexed postId, address indexed author, string content);
    event PostLiked(uint256 indexed postId, address indexed user);
    event PostUnliked(uint256 indexed postId, address indexed user);
    event UserFollowed(address indexed follower, address indexed following);
    event UserUnfollowed(address indexed follower, address indexed unfollowing);

    // Modifiers
    modifier onlyRegisteredUser() {
        require(users[msg.sender].isRegistered, "User must be registered");
        _;
    }

    modifier postExists(uint256 _postId) {
        require(_postId <= postCounter && posts[_postId].isActive, "Post does not exist");
        _;
    }

    // Core Function 1: Register User
    function registerUser(
        string memory _username,
        string memory _bio,
        string memory _profileImageHash
    ) external {
        require(!users[msg.sender].isRegistered, "User already registered");
        require(bytes(_username).length > 0, "Username cannot be empty");
        require(bytes(_username).length <= 50, "Username too long");

        users[msg.sender] = User({
            username: _username,
            bio: _bio,
            profileImageHash: _profileImageHash,
            postCount: 0,
            followerCount: 0,
            followingCount: 0,
            isRegistered: true
        });

        userCounter++;
        emit UserRegistered(msg.sender, _username);
    }

    // Core Function 2: Create Post
    function createPost(
        string memory _content,
        string memory _imageHash
    ) external onlyRegisteredUser {
        require(bytes(_content).length > 0, "Content cannot be empty");
        require(bytes(_content).length <= 1000, "Content too long");

        postCounter++;
        
        posts[postCounter] = Post({
            id: postCounter,
            author: msg.sender,
            content: _content,
            imageHash: _imageHash,
            timestamp: block.timestamp,
            likes: 0,
            isActive: true
        });

        userPosts[msg.sender].push(postCounter);
        users[msg.sender].postCount++;

        emit PostCreated(postCounter, msg.sender, _content);
    }

    // Core Function 3: Like/Unlike Post
    function toggleLikePost(uint256 _postId) external onlyRegisteredUser postExists(_postId) {
        if (postLikes[_postId][msg.sender]) {
            // Unlike the post
            postLikes[_postId][msg.sender] = false;
            posts[_postId].likes--;
            emit PostUnliked(_postId, msg.sender);
        } else {
            // Like the post
            postLikes[_postId][msg.sender] = true;
            posts[_postId].likes++;
            emit PostLiked(_postId, msg.sender);
        }
    }

    // Additional Function: Follow/Unfollow User
    function toggleFollowUser(address _userToFollow) external onlyRegisteredUser {
        require(_userToFollow != msg.sender, "Cannot follow yourself");
        require(users[_userToFollow].isRegistered, "User to follow is not registered");

        if (following[msg.sender][_userToFollow]) {
            // Unfollow
            following[msg.sender][_userToFollow] = false;
            users[_userToFollow].followerCount--;
            users[msg.sender].followingCount--;
            emit UserUnfollowed(msg.sender, _userToFollow);
        } else {
            // Follow
            following[msg.sender][_userToFollow] = true;
            users[_userToFollow].followerCount++;
            users[msg.sender].followingCount++;
            emit UserFollowed(msg.sender, _userToFollow);
        }
    }

    // View Functions
    function getUser(address _userAddress) external view returns (User memory) {
        require(users[_userAddress].isRegistered, "User not registered");
        return users[_userAddress];
    }

    function getPost(uint256 _postId) external view returns (Post memory) {
        require(_postId <= postCounter && posts[_postId].isActive, "Post does not exist");
        return posts[_postId];
    }

    function getUserPosts(address _userAddress) external view returns (uint256[] memory) {
        return userPosts[_userAddress];
    }

    function isFollowing(address _follower, address _following) external view returns (bool) {
        return following[_follower][_following];
    }

    function hasLikedPost(uint256 _postId, address _user) external view returns (bool) {
        return postLikes[_postId][_user];
    }

    function getTotalUsers() external view returns (uint256) {
        return userCounter;
    }

    function getTotalPosts() external view returns (uint256) {
        return postCounter;
    }
}
