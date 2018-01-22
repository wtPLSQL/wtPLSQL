/*
 * Called from the boilerplate html when a new main tab is selected.
 */
function onSelectMainTab(node, newMainIndex) {
    highlightMainTab(node);
    showMain(newMainIndex);
}

/*
 * Called from the boilerplate html when a new child tab is selected.
 */
function onSelectChildTab(node, newChildIndex) {
    highlightChildTab(node);
    showChild(newChildIndex, rowIndex);
}

/*
 * Called from the report specific code when a new master row is selected.
 */
function onSelectRowIndex(rowIndex) {
    showChild(childIndex, rowIndex);
}

/**********************************************************************************************************************
 Implementation code
 ***********************************************************************************************************************/

var mainIndex = 0;
var childIndex = 0;
var rowIndex = 0;
var selectedChildReport;

/*
 * Modifies the UI by highlighting the selected main tab and unhighlighting the rest.
 */
function highlightMainTab(node) {
    if (node.className != "currentmaintab") {
        var tabNodes = document.getElementById("maintabs").children;
        for (var t = 0;t < tabNodes.length;t++) {
            var tabNode = tabNodes[t];
            if (tabNode.className == "currentmaintab") {
                tabNode.className = "maintab";
            }
        }
        node.className = "currentmaintab";
    }
}

/*
 * Modifies the UI by highlighting the selected child tab and unhighlighting the rest.
 */
function highlightChildTab(node) {
    if (node.className != "currentchildtab") {
        var tabNodes = document.getElementById("ChildTabs." + mainIndex).children;
        for (var t = 0;t < tabNodes.length;t++) {
            var tabNode = tabNodes[t];
            if (tabNode.className == "currentchildtab") {
                tabNode.className = "childtab";
            }
        }
        node.className = "currentchildtab";
    }
}

/*
 * Modifies the UI by showing the selected main report and hiding the rest.
 */
function showMain(newMainIndex) {
    if (newMainIndex != mainIndex) {
        var newMainId = "Master." + newMainIndex;
        var mainElements = document.getElementById("masterreports").children;
        for (var m = 0;m < mainElements.length;m++) {
            var mainElement = mainElements[m];
            if (mainElement.id == newMainId) {
                mainElement.children[0].className = "currentmasterreport";
                var childReportElement = document.getElementById("ChildReports." + newMainIndex);
                if (childReportElement != null) {
                    var childElements = childReportElement.children;
                    for (var c = 0;c < childElements.length;c++) {
                        var childElement = childElements[c];
                        if (childElement.children[0].className == "currentchildreport") {
                            var childReportId = childElement.id;
                            var firstDot = childReportId.indexOf(".");
                            var secondDot = childReportId.indexOf(".", firstDot + 1);
                            var thirdDot = childReportId.indexOf(".", secondDot + 1);
                            selectedChildReport = childElement;
                            rowIndex = parseInt(childReportId.substring(secondDot + 1, thirdDot));
                            childIndex = parseInt(childReportId.substring(firstDot + 1, secondDot));
                        }
                    }
                }
                mainIndex = newMainIndex;
            }
            else {
                var firstChildElement = mainElement.children[0];
                if (firstChildElement.className == "currentmasterreport") {
                    firstChildElement.className = "masterreport";
                }
            }
        }
    }
}

/*
 * Modifies the UI by showing the selected child report and hiding the rest.
 */
function showChild(newChildIndex, newRowIndex) {
    if (newRowIndex != rowIndex || newChildIndex != childIndex) {
        if (selectedChildReport == null) {
            selectedChildReport = document.getElementById("ChildReports." + mainIndex).children[0];
        }
        selectedChildReport.children[0].className = "childreport";
        var newChildId = "Child." + newChildIndex + "." + newRowIndex + "." + mainIndex;
        selectedChildReport = document.getElementById(newChildId);
        selectedChildReport.children[0].className = "currentchildreport";
        childIndex = newChildIndex;
        rowIndex = newRowIndex;
    }
}/**********************************************************************************************************************
 Table report code
***********************************************************************************************************************/

var table_selectedRows = new Array();

function table_onSelectMasterRow(node, tableNo, newMasterIndex) {
    table_onSelectRow(node, tableNo);
    onSelectRowIndex(newMasterIndex);
}

function table_onSelectRow(node, tableNo) {    
    if (node.className != "currentrow") {
        previousRow = table_selectedRows[tableNo];
        if (previousRow == null) {
            previousRow = node.parentNode.children[1];
        }
        previousRow.className = "";
        var previousCells = previousRow.children;
        for (var pc = 0;pc < previousCells.length;pc++) {
            previousCells[pc].className = "";        
        }
        node.className = "currentrow";
        var nodeCells = node.children;
        for (var nc = 0;nc < nodeCells.length;nc++) {
            nodeCells[nc].className = "currentcell";        
        }
        table_selectedRows[tableNo] = node;
    }
}
