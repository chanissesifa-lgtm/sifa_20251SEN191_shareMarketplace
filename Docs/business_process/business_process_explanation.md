
# Phase I: Business Process Modeling
**Project:** Local Company Share Marketplace  
**Student:** Sifa Sonia Chanisse (ID: 20251SEN191 | Group D)  
**Instructor:** Eric Maniraguha  

## 1. Process Overview & Objective
The **Verified Share Purchase & Investor Allocation** process governs how retail investors evaluate local enterprises and purchase equity shares securely. Its primary objective is to ensure transparency and prevent overselling or overdrafts by automatically validating share availability and investor funds before recording any financial transaction.

## 2. Actors & Swimlane Responsibilities
* **Company Administrator:** Registers verified local enterprises, publishes quarterly financial performance (`RISING`, `STABLE`, `FALLING`), and lists available share offerings.
* **Retail Investor:** Browses active companies, reviews financial performance indicators, and submits a share purchase request.
* **System Marketplace Engine (Oracle PL/SQL):** Validates investor wallet balances and available share pools, enforces business rules via triggers, executes atomic ledger updates, and logs every action in the audit trail.

## 3. Step-by-Step Workflow & CRUD Data Activities
1. **Company & Offering Setup (Create):** The Company Administrator registers the company in `COMPANIES`, uploads quarterly metrics in `COMPANY_PERFORMANCE`, and creates a share block in `SHARE_OFFERINGS`.
2. **Market Discovery (Read):** The Retail Investor queries `COMPANIES`, `COMPANY_PERFORMANCE`, and `SHARE_OFFERINGS` to compare rising companies and share prices.
3. **Purchase Request Submission:** The investor selects an offering and submits a buy order specifying the desired share quantity.
4. **Automated Validation (Decision Gateway):** The System Engine checks whether `available_shares >= requested_shares` and `wallet_balance >= total_cost`.
   * **If Invalid (Exception Path):** A `BEFORE INSERT` trigger blocks the order, rolls back changes, records a `PURCHASE_FAILED` entry (**Create**) in `AUDIT_LOG`, and notifies the investor.
   * **If Valid (Success Path):** The system inserts the purchase (**Create**) into `TRANSACTIONS`, deducts purchased shares (**Update**) in `SHARE_OFFERINGS`, deducts the purchase cost (**Update**) in `INVESTORS`, and writes a `PURCHASE_SUCCESS` entry (**Create**) in `AUDIT_LOG`.
5. **Portfolio Confirmation (Read):** The investor views their updated wallet balance and computed equity portfolio value.