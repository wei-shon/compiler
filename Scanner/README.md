# ScannerTest
## Description 
在 編譯器中， token 是組成程式的最小單位，需要由 Scanner 先把 input text 按照規
則轉為 Token ，才能讓 Parser 進行處理。請依照題目規則，試著寫一個 Scanner 來
取得 Tokens 並印出。

| Terminal | Regular Expression |
| -------- |:------------------ |
| NUM      | ( [1 9][0 9]* )\0  |
| PLUS     | \+                 |
| MINUS    | \-                 |
| MUL      | \*                 |
| DIV      | \\                 |
| LPR      | \(                 |
| RPR      | \)                 |

## Input Format 
輸入一條運算式， 每筆測試資料只會有一個運算式 ，但其中可能會夾雜空格或換行。
此題的測試資料不會有錯誤的測試資料
此題的測試資料會在 1000 字元內 不包含換行號
## Output Format 
請在切割後輸出其 Token 種類，例如 則輸出 PLUS 。
若為數字，需附上其數值，並以一個空白做為區隔。例如 0 則需輸出 NUM 0 ，以此
類推。
每個 token 輸出後請以 \n 分隔。

|Sample Input 1
1+2
Sample Output 1
NUM 1
PLUS
NUM 2


Sample Input 2
( 1+
2
Sa mple Output 2
LPR
NUM 1
PLUS
MINUS
NUM 2
RPR


Sample Input 3
(1 +
2 * 3
/ 4
Sample Output 3
LPR
LPR
NUM 1
PLUS
NUM 2
MUL
NUM 3
DIV
NUM 4
RPR
RPR