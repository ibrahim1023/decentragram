pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";
  uint public imageCount = 0;

  mapping (uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated (
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  function uploadImage (string memory _imageHash, string memory _description) public {
    require(bytes(_imageHash).length > 0, 'Hash cannot be empty');
    require(bytes(_description).length > 0, 'Description cannot be empty');
    require(msg.sender != address(0), 'Address is invalid');

    imageCount++;
    images[imageCount] = Image(imageCount, _imageHash, _description, 0, msg.sender);

    emit ImageCreated(imageCount, _imageHash, _description, 0, msg.sender);
  }

  function tipImageOwner (uint _id) public payable {
    require(_id > 0 && _id <= imageCount);

    Image memory _image = images[_id];

    address payable _author = _image.author;
    address(_author).transfer(msg.value);

    _image.tipAmount = _image.tipAmount + msg.value;
    images[_id] = _image;

    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
  
}