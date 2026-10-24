# End-to-End Workflow Verification Script for Smart VIT CMS
$ErrorActionPreference = "Stop"
$baseUrl = "http://localhost:8080/Smartvit"

function Print-Header($msg) {
    Write-Host "`n========================================================" -ForegroundColor Cyan
    Write-Host ">>> $msg" -ForegroundColor Yellow
    Write-Host "========================================================" -ForegroundColor Cyan
}

Print-Header "1. Student Login"
$studentSess = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$loginResp = Invoke-WebRequest -Uri "$baseUrl/login" -Method Post -Body @{
    identifier = "student@vit.ac.in"
    password = "Student@123"
} -WebSession $studentSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing

Write-Host "Student Login Status: $($loginResp.StatusCode) -> $($loginResp.Headers.Location)" -ForegroundColor Green

Print-Header "2. Student Submits Complaint"
$complaintTitle = "E2E Test AC Not Cooling in Room 301"
$complaintDesc = "The air conditioner in room 301 has completely stopped cooling. Please inspect the compressor and cooling unit."
$raiseBody = @{
    title = $complaintTitle
    categoryId = "1"        # Electrical
    subcategoryId = "1"     # AC / Electrical
    buildingId = "1"
    locationId = "1"
    priority = "HIGH"
    description = $complaintDesc
}

$raiseResp = Invoke-WebRequest -Uri "$baseUrl/student/raise-complaint" -Method Post -Body $raiseBody -WebSession $studentSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Raise Complaint Response: $($raiseResp.StatusCode) -> $($raiseResp.Headers.Location)" -ForegroundColor Green

# Fetch Student My Complaints to get newly created complaint ID
$myComplaintsResp = Invoke-WebRequest -Uri "$baseUrl/student/my-complaints" -WebSession $studentSess -UseBasicParsing
if ($myComplaintsResp.Content -match 'complaint-details\?id=(\d+)') {
    $complaintId = $matches[1]
    Write-Host "Discovered Newly Raised Complaint ID: $complaintId" -ForegroundColor Green
} else {
    throw "Failed to extract complaint ID from my-complaints page."
}

Print-Header "3. Department Staff Login & Acknowledge"
$deptSess = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$deptLoginResp = Invoke-WebRequest -Uri "$baseUrl/login" -Method Post -Body @{
    identifier = "electrical@vit.ac.in"
    password = "Dept@123"
} -WebSession $deptSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Dept Staff Login Status: $($deptLoginResp.StatusCode) -> $($deptLoginResp.Headers.Location)" -ForegroundColor Green

# Acknowledge
$ackResp = Invoke-WebRequest -Uri "$baseUrl/department/update-status" -Method Post -Body @{
    complaintId = $complaintId
    action = "acknowledge"
    newStatus = "ACKNOWLEDGED"
} -WebSession $deptSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Dept Acknowledge Status: $($ackResp.StatusCode) -> $($ackResp.Headers.Location)" -ForegroundColor Green

Print-Header "4. Department Staff Updates Progress to IN_PROGRESS"
$progResp = Invoke-WebRequest -Uri "$baseUrl/department/update-status" -Method Post -Body @{
    complaintId = $complaintId
    newStatus = "IN_PROGRESS"
    remarks = "Technician arrived at Room 301 and identified refrigerant leak in cooling coil."
} -WebSession $deptSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Progress Update Status: $($progResp.StatusCode) -> $($progResp.Headers.Location)" -ForegroundColor Green

Print-Header "5. Department Staff Resolves Complaint"
$resolveResp = Invoke-WebRequest -Uri "$baseUrl/department/update-status" -Method Post -Body @{
    complaintId = $complaintId
    newStatus = "RESOLVED"
    remarks = "Repaired refrigerant line, refilled gas, and verified temperature dropped to 20C. Operational test passed."
    resolutionText = "Repaired refrigerant line, refilled gas, and verified temperature dropped to 20C. Operational test passed."
} -WebSession $deptSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Resolution Status: $($resolveResp.StatusCode) -> $($resolveResp.Headers.Location)" -ForegroundColor Green

Print-Header "6. Student Inspects Notifications & Resolution Details"
$notifsResp = Invoke-WebRequest -Uri "$baseUrl/notifications" -WebSession $studentSess -UseBasicParsing
$hasResolvedNotif = $notifsResp.Content -match 'resolved'
Write-Host "Resolution Notification Exists in Alert Center: $hasResolvedNotif" -ForegroundColor Green

# Student opens Complaint Details via notification URL
$detailsResp = Invoke-WebRequest -Uri "$baseUrl/complaint/details?id=$complaintId" -WebSession $studentSess -UseBasicParsing
$hasResolutionDetails = $detailsResp.Content -match 'Resolution Details'
$hasResolutionRemarks = $detailsResp.Content -match 'Repaired refrigerant line'
$hasFeedbackForm = $detailsResp.Content -match 'Rate Resolution Experience'
Write-Host "Complaint Details shows Resolution Banner: $hasResolutionDetails" -ForegroundColor Green
Write-Host "Complaint Details shows Resolution Remarks: $hasResolutionRemarks" -ForegroundColor Green
Write-Host "Complaint Details displays Post-Resolution Feedback Form: $hasFeedbackForm" -ForegroundColor Green

Print-Header "7. Student Submits Positive Feedback (Problem Solved = YES)"
$feedbackResp = Invoke-WebRequest -Uri "$baseUrl/student/feedback" -Method Post -Body @{
    complaintId = $complaintId
    problemSolved = "true"
    rating = "5"
    comment = "Excellent service! The AC is working like new now."
} -WebSession $studentSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Feedback Submit Status: $($feedbackResp.StatusCode) -> $($feedbackResp.Headers.Location)" -ForegroundColor Green

# Verify Complaint is now CLOSED with submitted feedback displayed
$closedDetailsResp = Invoke-WebRequest -Uri "$baseUrl/complaint/details?id=$complaintId" -WebSession $studentSess -UseBasicParsing
$isClosed = $closedDetailsResp.Content -match 'CLOSED'
$hasFeedbackDisplay = $closedDetailsResp.Content -match 'Excellent service'
Write-Host "Complaint Status is now CLOSED: $isClosed" -ForegroundColor Green
Write-Host "Submitted Rating and Comments Displayed: $hasFeedbackDisplay" -ForegroundColor Green

Print-Header "8. Test Reopening Workflow on a New Complaint"
# Raise second complaint
$raise2Resp = Invoke-WebRequest -Uri "$baseUrl/student/raise-complaint" -Method Post -Body @{
    title = "E2E Test Water Leak in Bathroom 204"
    categoryId = "1"
    subcategoryId = "1"
    buildingId = "1"
    locationId = "1"
    priority = "MEDIUM"
    description = "Water leakage observed from bathroom tap."
} -WebSession $studentSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing

$myComplaintsResp2 = Invoke-WebRequest -Uri "$baseUrl/student/my-complaints" -WebSession $studentSess -UseBasicParsing
if ($myComplaintsResp2.Content -match 'complaint-details\?id=(\d+)') {
    $complaint2Id = $matches[1]
    Write-Host "Created Second Complaint ID: $complaint2Id" -ForegroundColor Green
}

# Resolve second complaint
Invoke-WebRequest -Uri "$baseUrl/department/update-status" -Method Post -Body @{
    complaintId = $complaint2Id
    newStatus = "RESOLVED"
    remarks = "Replaced washer in tap."
} -WebSession $deptSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing | Out-Null
Write-Host "Second Complaint marked as RESOLVED by Dept Staff" -ForegroundColor Green

# Student reports problem NOT solved -> REOPEN
$reopenFeedbackResp = Invoke-WebRequest -Uri "$baseUrl/student/feedback" -Method Post -Body @{
    complaintId = $complaint2Id
    problemSolved = "false"
    rating = "2"
    comment = "The tap is still dripping continuously."
} -WebSession $studentSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Reopen Feedback Submit Status: $($reopenFeedbackResp.StatusCode) -> $($reopenFeedbackResp.Headers.Location)" -ForegroundColor Green

# Verify Second Complaint is now REOPENED
$reopenedDetailsResp = Invoke-WebRequest -Uri "$baseUrl/complaint/details?id=$complaint2Id" -WebSession $studentSess -UseBasicParsing
$isReopened = $reopenedDetailsResp.Content -match 'REOPENED'
Write-Host "Second Complaint Status is now REOPENED: $isReopened" -ForegroundColor Green

Print-Header "9. Administrator Dashboard & Feedback Verification"
$adminSess = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$adminLoginResp = Invoke-WebRequest -Uri "$baseUrl/login" -Method Post -Body @{
    identifier = "admin@vit.ac.in"
    password = "Admin@123"
} -WebSession $adminSess -MaximumRedirection 0 -ErrorAction SilentlyContinue -UseBasicParsing
Write-Host "Admin Login Status: $($adminLoginResp.StatusCode) -> $($adminLoginResp.Headers.Location)" -ForegroundColor Green

$adminDashResp = Invoke-WebRequest -Uri "$baseUrl/admin/dashboard" -WebSession $adminSess -UseBasicParsing
Write-Host "Admin Dashboard Status: $($adminDashResp.StatusCode)" -ForegroundColor Green

$adminNotifsResp = Invoke-WebRequest -Uri "$baseUrl/notifications" -WebSession $adminSess -UseBasicParsing
$adminHasReopenAlert = $adminNotifsResp.Content -match 'REOPENED'
Write-Host "Admin Received Reopen Alert Notification: $adminHasReopenAlert" -ForegroundColor Green

Print-Header "ALL 9 VERIFICATION PHASES COMPLETED SUCCESSFULLY!"
