## Things you need to do:

- Project.sol file - Rename this file and add the solidity code inside it.
- deploy.js file - Add the deploy.js (javascript) code inside it.
- .env.example - Add the Private Key of your MetaMask Wallet's account.
- Readme.md file - Add the Readme content inside this file.
- package.json file – Replace the `"name"` property value from `"Project-Title"` to your actual project title. <br/>
*Example:* `"name": "crowdfunding-smartcontract"`
# Decentralized Social Media

## Project Description

Decentralized Social Media is a blockchain-based social networking platform that empowers users with true ownership of their content and data. Built on the Core blockchain, this platform eliminates centralized control, censorship, and data harvesting by traditional social media companies. Users can create posts, interact with content, follow other users, and build communities in a completely decentralized environment.

The platform leverages smart contracts to ensure transparency, immutability, and user sovereignty over their digital presence. All interactions are recorded on the blockchain, providing a permanent and tamper-proof record of social activities while maintaining user privacy and control.

## Project Vision

Our vision is to create a social media ecosystem where:

- **Users own their data** - No central authority can access, modify, or monetize user content without permission
- **Content is censorship-resistant** - Posts and interactions are stored on the blockchain, making them immutable and resistant to takedowns
- **Creators are fairly compensated** - Direct monetization opportunities without platform intermediaries taking excessive fees
- **Privacy is protected** - Users maintain control over their personal information and can choose what to share
- **Communities self-govern** - Decentralized governance allows communities to set their own rules and standards
- **Innovation thrives** - Open-source nature encourages community contributions and platform improvements

## Key Features

### Core Functionality
- **User Registration**: Create decentralized profiles with username, bio, and profile image
- **Content Creation**: Post text content with optional image attachments (IPFS integration)
- **Social Interactions**: Like/unlike posts and follow/unfollow other users
- **Content Discovery**: Browse posts from followed users and explore trending content

### Blockchain Benefits
- **Immutable Records**: All posts and interactions are permanently stored on the blockchain
- **Decentralized Storage**: Content stored on IPFS ensures availability without central servers
- **Transparent Operations**: All platform activities are publicly verifiable on the blockchain
- **User Ownership**: Users retain full control over their profiles and content

### Security Features
- **Access Control**: Only registered users can create posts and interact with content
- **Input Validation**: Comprehensive validation for usernames, content length, and data integrity
- **Event Logging**: All important actions emit events for transparency and monitoring

### Gas Optimization
- **Efficient Storage**: Optimized data structures to minimize storage costs
- **Batch Operations**: Support for multiple interactions in single transactions
- **Smart Indexing**: Efficient mapping structures for quick data retrieval

## Future Scope

### Short-term Enhancements (3-6 months)
- **Comments System**: Enable threaded discussions on posts
- **Content Moderation**: Community-driven flagging and moderation tools
- **Media Support**: Enhanced support for videos, audio, and rich media content
- **Mobile App**: Native mobile applications for iOS and Android
- **Search Functionality**: Advanced search and filtering capabilities

### Medium-term Features (6-12 months)
- **Monetization Tools**: Tipping, NFT integration, and creator subscription models
- **Community Features**: Groups, channels, and specialized community spaces
- **Cross-chain Support**: Integration with multiple blockchain networks
- **Advanced Privacy**: Zero-knowledge proofs for private interactions
- **Governance Token**: Platform governance through decentralized voting mechanisms

### Long-term Vision (1-2 years)
- **AI Integration**: Content recommendation algorithms run on decentralized infrastructure
- **Metaverse Integration**: Virtual reality and 3D social experiences
- **Enterprise Solutions**: Business-focused social networking tools
- **Global Scaling**: Layer 2 solutions for mass adoption and reduced transaction costs
- **Interoperability**: Seamless integration with other decentralized platforms and protocols

### Technical Roadmap
- **Performance Optimization**: Advanced caching and state management
- **Security Audits**: Regular third-party security assessments
- **Developer Tools**: SDKs and APIs for third-party integrations
- **Analytics Dashboard**: Comprehensive user and platform analytics
- **Backup Solutions**: Decentralized backup and recovery mechanisms

## Getting Started

### Prerequisites
- Node.js (v16 or later)
- npm or yarn
- MetaMask or compatible Web3 wallet
- Core Testnet 2 tokens for deployment

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd decentralized-social-media

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your private key and configuration

# Compile contracts
npm run compile

# Deploy to Core Testnet 2
npm run deploy
```

### Contract Interaction
After deployment, you can interact with the contract using:
- Web3 libraries (ethers.js, web3.js)
- Hardhat console
- Frontend applications
- Direct blockchain explorers

## Contributing

We welcome contributions from the community! Please read our contributing guidelines and submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

==================== test/Project.test.js ====================
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Project - Decentralized Social Media", function () {
  let project;
  let owner;
  let user1;
  let user2;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    
    const Project = await ethers.getContractFactory("Project");
    project = await Project.deploy();
    await project.waitForDeployment();
  });

  describe("User Registration", function () {
    it("Should register a new user", async function () {
      await project.connect(user1).registerUser("alice", "Hello World", "QmHash123");
      
      const user = await project.getUser(user1.address);
      expect(user.username).to.equal("alice");
      expect(user.bio).to.equal("Hello World");
      expect(user.isRegistered).to.be.true;
    });

    it("Should prevent duplicate registration", async function () {
      await project.connect(user1).registerUser("alice", "Hello World", "QmHash123");
      
      await expect(
        project.connect(user1).registerUser("alice2", "Hello Again", "QmHash456")
      ).to.be.revertedWith("User already registered");
    });
  });

  describe("Post Creation", function () {
    beforeEach(async function () {
      await project.connect(user1).registerUser("alice", "Hello World", "QmHash123");
    });

    it("Should create a new post", async function () {
      await project.connect(user1).createPost("My first post!", "QmImageHash");
      
      const post = await project.getPost(1);
      expect(post.content).to.equal("My first post!");
      expect(post.author).to.equal(user1.address);
      expect(post.likes).to.equal(0);
    });

    it("Should prevent unregistered users from posting", async function () {
      await expect(
        project.connect(user2).createPost("Unauthorized post", "")
      ).to.be.revertedWith("User must be registered");
    });
  });

  describe("Post Interactions", function () {
    beforeEach(async function () {
      await project.connect(user1).registerUser("alice", "Hello World", "QmHash123");
      await project.connect(user2).registerUser("bob", "Hi there", "QmHash456");
      await project.connect(user1).createPost("My first post!", "QmImageHash");
    });

    it("Should like a post", async function () {
      await project.connect(user2).toggleLikePost(1);
      
      const post = await project.getPost(1);
      expect(post.likes).to.equal(1);
      
      const hasLiked = await project.hasLikedPost(1, user2.address);
      expect(hasLiked).to.be.true;
    });

    it("Should unlike a post", async function () {
      await project.connect(user2).toggleLikePost(1);
      await project.connect(user2).toggleLikePost(1);
      
      const post = await project.getPost(1);
      expect(post.likes).to.equal(0);
      
      const hasLiked = await project.hasLikedPost(1, user2.address);
      expect(hasLiked).to.be.false;
    });
  });

  describe("Follow System", function () {
    beforeEach(async function () {
      await project.connect(user1).registerUser("alice", "Hello World", "QmHash123");
      await project.connect(user2).registerUser("bob", "Hi there", "QmHash456");
    });

    it("Should follow a user", async function () {
      await project.connect(user1).toggleFollowUser(user2.address);
      
      const isFollowing = await project.isFollowing(user1.address, user2.address);
      expect(isFollowing).to.be.true;
      
      const user2Data = await project.getUser(user2.address);
      expect(user2Data.followerCount).to.equal(1);
    });

    it("Should unfollow a user", async function () {
      await project.connect(user1).toggleFollowUser(user2.address);
      await project.connect(user1).toggleFollowUser(user2.address);
      
      const isFollowing = await project.isFollowing(user1.address, user2.address);
      expect(isFollowing).to.be.false;
      
      const user2Data = await project.getUser(user2.address);
      expect(user2Data.followerCount).to.equal(0);
    });
  });
});
