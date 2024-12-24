// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdlendingPlatform {
    struct Loan {
        address payable borrower;
        uint256 amount;
        uint256 interestRate; // Annual interest rate in percentage (e.g., 5 for 5%)
        uint256 duration; // Duration in days
        uint256 deadline;
        uint256 totalAmountToRepay;
        uint256 amountFunded;
        bool isActive;
        bool isFunded;
        bool isRepaid;
    }

    struct Lender {
        uint256 amountLent;
        bool hasLent;
    }

    mapping(uint256 => Loan) public loans;
    mapping(uint256 => mapping(address => Lender)) public lenders;
    
    uint256 public loanCount;
    uint256 public platformFee = 1; // 1% platform fee

    event LoanCreated(uint256 indexed loanId, address borrower, uint256 amount, uint256 interestRate);
    event LoanFunded(uint256 indexed loanId, address lender, uint256 amount);
    event LoanRepaid(uint256 indexed loanId, uint256 amount);
    event LoanCancelled(uint256 indexed loanId);
    event WithdrawnLenderFunds(uint256 indexed loanId, address lender, uint256 amount);

    modifier onlyBorrower(uint256 _loanId) {
        require(msg.sender == loans[_loanId].borrower, "Only borrower can call this function");
        _;
    }

    modifier loanExists(uint256 _loanId) {
        require(_loanId < loanCount, "Loan does not exist");
        _;
    }

    // Function 1: Create a new loan request
    function createLoan(
        uint256 _amount,
        uint256 _interestRate,
        uint256 _duration
    ) external returns (uint256) {
        require(_amount > 0, "Amount must be greater than 0");
        require(_interestRate > 0, "Interest rate must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        uint256 totalInterest = (_amount * _interestRate * _duration) / (365 * 100);
        uint256 platformFeeAmount = (_amount * platformFee) / 100;
        uint256 totalAmountToRepay = _amount + totalInterest + platformFeeAmount;

        loans[loanCount] = Loan({
            borrower: payable(msg.sender),
            amount: _amount,
            interestRate: _interestRate,
            duration: _duration,
            deadline: block.timestamp + (_duration * 1 days),
            totalAmountToRepay: totalAmountToRepay,
            amountFunded: 0,
            isActive: true,
            isFunded: false,
            isRepaid: false
        });

        emit LoanCreated(loanCount, msg.sender, _amount, _interestRate);
        loanCount++;
        return loanCount - 1;
    }

    // Function 2: Fund a loan
    function fundLoan(uint256 _loanId) external payable loanExists(_loanId) {
        Loan storage loan = loans[_loanId];
        
        require(loan.isActive, "Loan is not active");
        require(!loan.isFunded, "Loan is already fully funded");
        require(msg.value > 0, "Amount must be greater than 0");
        require(loan.amountFunded + msg.value <= loan.amount, "Amount exceeds loan requirement");

        lenders[_loanId][msg.sender].amountLent += msg.value;
        lenders[_loanId][msg.sender].hasLent = true;
        loan.amountFunded += msg.value;

        if (loan.amountFunded == loan.amount) {
            loan.isFunded = true;
            loan.borrower.transfer(loan.amount);
        }

        emit LoanFunded(_loanId, msg.sender, msg.value);
    }

    // Helper functions
    function repayLoan(uint256 _loanId) external payable loanExists(_loanId) onlyBorrower(_loanId) {
        Loan storage loan = loans[_loanId];
        
        require(loan.isFunded, "Loan is not funded");
        require(!loan.isRepaid, "Loan is already repaid");
        require(msg.value == loan.totalAmountToRepay, "Incorrect repayment amount");

        loan.isRepaid = true;
        loan.isActive = false;

        emit LoanRepaid(_loanId, msg.value);
    }

    function cancelLoan(uint256 _loanId) external loanExists(_loanId) onlyBorrower(_loanId) {
        Loan storage loan = loans[_loanId];
        
        require(loan.isActive, "Loan is not active");
        require(!loan.isFunded, "Cannot cancel funded loan");

        loan.isActive = false;
        emit LoanCancelled(_loanId);
    }

    function withdrawLenderFunds(uint256 _loanId) external loanExists(_loanId) {
        Loan storage loan = loans[_loanId];
        Lender storage lender = lenders[_loanId][msg.sender];
        
        require(lender.hasLent, "No lending record found");
        require(loan.isRepaid, "Loan is not repaid yet");

        uint256 lenderShare = (lender.amountLent * loan.totalAmountToRepay) / loan.amount;
        lender.amountLent = 0;
        lender.hasLent = false;

        payable(msg.sender).transfer(lenderShare);
        emit WithdrawnLenderFunds(_loanId, msg.sender, lenderShare);
    }

    function getLoanDetails(uint256 _loanId) external view loanExists(_loanId) returns (
        address borrower,
        uint256 amount,
        uint256 interestRate,
        uint256 duration,
        uint256 deadline,
        uint256 totalAmountToRepay,
        uint256 amountFunded,
        bool isActive,
        bool isFunded,
        bool isRepaid
    ) {
        Loan storage loan = loans[_loanId];
        return (
            loan.borrower,
            loan.amount,
            loan.interestRate,
            loan.duration,
            loan.deadline,
            loan.totalAmountToRepay,
            loan.amountFunded,
            loan.isActive,
            loan.isFunded,
            loan.isRepaid
        );
    }
}