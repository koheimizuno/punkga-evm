// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract PunkgaRewardV2 is
    Initializable,
    ERC721Upgradeable,
    ERC721URIStorageUpgradeable,
    ERC721PausableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    // Events emit by the contract
    event RewardMinted(address indexed to, uint256 indexed tokenId);
    event UserInfoUpdated(address indexed user, uint256 level, uint64 totalXp);
    event SetVerifier(address indexed add, bool value);

    uint256 private _nextTokenId;

    struct UserInfo {
        address userAddr;
        uint64 level;
        uint64 totalXp;
    }

    mapping(address => UserInfo) public userInfos;

    address public signer;
    mapping(uint256 => bool) public usedProof;

    struct Proof {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __ERC721_init("PunkgaReward", "PGR");
        __ERC721URIStorage_init();
        __ERC721Pausable_init();
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function getChainID() public view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function setSigner(address _signer) public onlyOwner {
        signer = _signer;
    }

    function _verifyProof(bytes memory encode, Proof memory _proof) internal view returns (bool) {
        bytes32 digest = keccak256(abi.encodePacked(getChainID(), address(this), encode));
        address signatory = ecrecover(digest, _proof.v, _proof.r, _proof.s);
        return signer == signatory;
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mintReward(address to, string memory uri, Proof memory proofs, uint256 requestId) public {
        bytes memory encodeData = abi.encodePacked(to, uri, msg.sender, requestId);
        uint256 pid = uint256(keccak256(abi.encode(proofs.r, proofs.s, proofs.v)));
        require(
            usedProof[pid] == false && _verifyProof(encodeData, proofs),
            "PunkgaReward: Wrong signer or duplicate proof"
        );
        usedProof[pid] = true;

        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit RewardMinted(to, tokenId);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721Upgradeable, ERC721PausableUpgradeable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function updateUserInfo(address _user, uint64 _level, uint64 _totalXp, Proof memory _proofs, uint256 _requestId) public {
        uint256 _level256 = _level;
        uint256 _totalXp256 = _totalXp;
        bytes memory encodeData = abi.encodePacked(_user, msg.sender, _level256, _totalXp256, _requestId);
        uint256 pid = uint256(keccak256(abi.encode(_proofs.r, _proofs.s, _proofs.v)));
        require(
            usedProof[pid] == false && _verifyProof(encodeData, _proofs),
            "PunkgaReward: Wrong signer or duplicate proof"
        );
        usedProof[pid] = true;

        userInfos[_user] = UserInfo(_user, _level, _totalXp);

        emit UserInfoUpdated(_user, _level, _totalXp);
    }
}
