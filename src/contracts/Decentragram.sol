pragma solidity ^0.5.0;

contract Decentragram {
    string public name = "Decentragram";
    //Store Images
    uint256 public imageCount = 0;
    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    //Create Images
    function uploadImage(string memory _imageHash, string memory _description)
        public
    {
        //Makes sure that the imagehash exits
        require(bytes(_imageHash).length > 0);

        //Makes sure that the image description exists
        require(bytes(_description).length > 0);

        //Makes sure that the uploader address exits
        //require(msg.sender != address(0x0));

        //increment imageid:
        imageCount++;

        //add image to ntract
        images[imageCount] = Image(
            imageCount,
            _imageHash,
            _description,
            0,
            msg.sender
        );

        //trigger an event
        emit ImageCreated(imageCount, _imageHash, _description, 0, msg.sender);
    }

    //Tip images
    function tipImageOwner(uint256 _id) public payable {
        //checking the id
        require(_id > 0 && _id <= imageCount);

        Image memory _image = images[_id];
        address payable _author = _image.author;
        address(_author).transfer(msg.value);

        //increment the tip amount
        _image.tipAmount = _image.tipAmount + msg.value;
        //update the image
        images[_id] = _image;

        //trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
