// SPDX-License-Identifier: Unlicensed
  pragma solidity >=0.7.0;

  
  contract BloodBank{
      // set the owner of the contract
      address owner;

       constructor() {
        owner = msg.sender;
    }

      // used to storing blood transaction
      struct BloodTransaction {
          PatientType patienttype;
          uint time;
          address from;
          address to;
      }



    
      // used for storing single patient records
     struct patient {
         string name;
         uint age;
         string bloodGroup;
         uint contactNo;
         string homeAdress;
         uint aadhaarNo;
         BloodTransaction[] bt;

     }
     // Array to store all the patient record and used to fetched patient record.
     patient[] patientRecord;

     // used for defining patient type.
     enum PatientType {
         Donor,
         Receiver
     }

     //  map is used to map the addhar card with the index number of the array where patient record is stored
    // this will prevent the use of loop in contract
     mapping (uint=> uint) patientRecordIndex;

      // used for notifying if function is executed or not
    event Successfull(string message);
     
   
     
     // function to get all the records
     function getAllRecod() external view returns(patient[] memory){
         return patientRecord;
     }
    // store the blood transaction
    function bloodTransaction(uint aadhaarNo, 
    PatientType _type,
    address _from,
    address _to) external {
        require (msg.sender == owner, "only hospital can update patient blood transaction data");
        //  get at which index the patient registartion details are saved
        uint index = patientRecordIndex[aadhaarNo];
        patientRecord[index].bt.push(BloodTransaction(_type, block.timestamp,_from, _to));
        emit Successfull ("patient blood transaction data is updated successfully");
    }

     // function to get specific user data
     function getPatientRecord(uint aadhaarNo) external view returns(patient memory){
         uint index = patientRecordIndex[aadhaarNo];
         return patientRecord[index];      
     }
     // function to register new patient
         function  newPatient(string memory _name, uint _age,string memory _bloodGroup,
          uint _contactNo, string memory _homeAddress, uint _aadhaarNo) external{

            // Since patient can be only registered by the hospital hence its required to check if the sender
        // is owner or not
              require (msg.sender == owner, "only hospital can register new patient");
              // get the  length of  the  array
              uint index = patientRecord.length;

              // insert records
              patientRecord.push();
              patientRecord[index].name = _name;
              patientRecord[index].age = _age;
              patientRecord[index].bloodGroup = _bloodGroup;
              patientRecord[index].contactNo = _contactNo;
              patientRecord[index].homeAdress = _homeAddress;
              patientRecord[index].aadhaarNo = _aadhaarNo;

              // // store the aaray index in the map against the user aadhaar number
              patientRecordIndex[_aadhaarNo] = index;
              emit Successfull("Patient added successfully");
          }
  }