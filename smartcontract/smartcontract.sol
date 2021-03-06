pragma solidity ^0.6.0;

contract SupplyChain {
    
    event Added(uint256 index);
    
    struct State{
        string description; //Location
        string temperature; //Temperature
        string locationName;
        address person;
    }
    
    struct Product{
        address creator;
        string productName;
        uint256 productId;
        string manufactureDate;
        string expiryDate;
        string batchNo;
        uint256 totalStates;
        mapping (uint256 => State) positions;
    }
    
    mapping(uint => Product) allProducts;
    uint256 items=1001;
    
    function concat(string memory _a, string memory _b) public returns (string memory){
        bytes memory bytes_a = bytes(_a);
        bytes memory bytes_b = bytes(_b);
        string memory length_ab = new string(bytes_a.length + bytes_b.length);
        bytes memory bytes_c = bytes(length_ab);
        uint k = 0;
        for (uint i = 0; i < bytes_a.length; i++) bytes_c[k++] = bytes_a[i];
        for (uint i = 0; i < bytes_b.length; i++) bytes_c[k++] = bytes_b[i];
        return string(bytes_c);
    }
    
    function newItem(string memory _text, string memory _mdate, string memory _edate, string memory bno) public returns (bool) {
        Product memory newItem = Product({creator: msg.sender, totalStates: 0,productName: _text, productId: items, manufactureDate: _mdate, expiryDate: _edate, batchNo: bno});
        allProducts[items]=newItem;
        items = items+1;
        emit Added(items-1);
        return true;
    }
    
    function addState(uint _productId, string memory info, string memory temp, string memory lname) public returns (string memory) {
        require(_productId<=items);
        
        State memory newState = State({person: msg.sender, description: info, temperature: temp, locationName: lname});//Add new things in add product here & in struct state
        
        allProducts[_productId].positions[ allProducts[_productId].totalStates ]=newState;
        
        allProducts[_productId].totalStates = allProducts[_productId].totalStates +1;
        return info;
    }
    
    
    function searchProduct(uint _productId) public returns (string memory) {

        require(_productId<=items);
        string memory output="<li><div class='direction-r'><div class='flag-wrapper'><span class='flag'>";
        output=concat(output, allProducts[_productId].positions[0].locationName);
        output=concat(output, allProducts[_productId].positions[0].description);
        output=concat(output, allProducts[_productId].productName);
        output=concat(output, allProducts[_productId].manufactureDate);
        output=concat(output, allProducts[_productId].expiryDate);
        output=concat(output, allProducts[_productId].positions[0].temperature);
        output=concat(output, allProducts[_productId].batchNo);
        output=concat(output, "</div></li>");
        
        
        for (uint256 j=1; j<allProducts[_productId].totalStates; j++){
            if(j%2 == 0){
                output=concat(output, "<li><div class='direction-r'><div class='flag-wrapper'><span class='flag'>");
            }
            else{
                output=concat(output, "<li><div class='direction-l'><div class='flag-wrapper'><span class='flag'>");
            }
            
            output=concat(output, allProducts[_productId].positions[j].locationName);
            output=concat(output, allProducts[_productId].positions[j].description);
            output=concat(output, allProducts[_productId].positions[j].temperature);
            output=concat(output, "</div></li>");
        }
        return output;
        
    }
    
}