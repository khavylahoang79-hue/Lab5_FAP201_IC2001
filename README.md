# Lab5_FAP201_IC2001
# Lab5_FAP201 – LFSR Delay & LED Demultiplexer

## Thông tin chung
- **Môn học:** FAP201 - FPGA Programming
- **Bài thực hành:** Lab05 - Linear Feedback Shift Register (LFSR) & LED Demux Routing (CLO1 & CLO2)
- **Tác giả:** La Hoàng Khả Vy (CE210538)
- **Mục tiêu:** Thiết kế, kiểm chứng và hiện thực bộ tạo trễ/xung nhấp nháy bằng thanh ghi dịch phản hồi tuyến tính (LFSR) kết hợp với mạch phân kênh (Demultiplexer) để định tuyến tín hiệu nhấp nháy đến 1 trong 4 đèn LED dựa trên 2 công tắc ngõ vào.

## Môi trường và Phần cứng
- **Công cụ phát triển:** Gowin EDA
- **Bo mạch (Board):** Xiaomeige ACG525
- **Chip FPGA (Target Device):** GW5A-LV25UG324C2/I1
- **Ngôn ngữ:** VHDL (IEEE 1164 STD_LOGIC)

## Nguyên lý hoạt động & Phân tích Architecture
- **Chuỗi dịch phản hồi tuyến tính (XNOR LFSR Counter):**
  * Sử dụng thanh ghi `r_LFSR` có độ rộng tham số hóa `G_WIDTH` (mặc định 22-bit trên thực tế phần cứng).
  * Phép phản hồi XNOR giữa bit cao nhất và bit kế cao nhất: `r_LFSR <= r_LFSR(G_WIDTH-2 downto 0) & (r_LFSR(G_WIDTH-1) xnor r_LFSR(G_WIDTH-2));` tạo chuỗi tạo trễ tuần hoàn[cite: 18].
- **Phát hiện hoàn tất chu kỳ (Done Detection) & Đảo trạng thái (Toggle):**
  * Tín hiệu `w_Done` lên mức `'1'` khi `r_LFSR` đạt trạng thái toàn bit `'0'` (`r_LFSR = (others => '0')`)[cite: 18].
  * Mỗi khi `w_Done = '1'`, thanh ghi `r_Toggle` đảo giá trị (`r_Toggle <= not r_Toggle;`), tạo ra chu kỳ nhấp nháy ổn định[cite: 18].
- **Phân kênh ngõ ra LED (Demultiplexer Selection):**
  * 2 công tắc ngõ vào `i_Switch_2` và `i_Switch_1` đóng vai trò là dòng chọn (Select lines)[cite: 18].
  * Tín hiệu nhấp nháy `r_Toggle` chỉ được định tuyến đến đúng 1 đèn LED được chọn, 3 đèn LED còn lại bị cưỡng bức về mức logic `'0'` (Tắt)[cite: 18].

---

## Bảng điều kiện định tuyến LED (Demux Selection Table)

| i_Switch_2 (KEY1) | i_Switch_1 (KEY0) | o_LED_1 (LED0) | o_LED_2 (LED1) | o_LED_3 (LED2) | o_LED_4 (LED3) | Trạng thái vật lý |
| :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `0` (Nhấn) | `0` (Nhấn) | `r_Toggle` | `0` | `0` | `0` | Chỉ LED1 nhấp nháy, các LED còn lại TẮT[cite: 18] |
| `0` (Nhấn) | `1` (Thả) | `0` | `r_Toggle` | `0` | `0` | Chỉ LED2 nhấp nháy, các LED còn lại TẮT[cite: 18] |
| `1` (Thả) | `0` (Nhấn) | `0` | `0` | `r_Toggle` | `0` | Chỉ LED3 nhấp nháy, các LED còn lại TẮT[cite: 18] |
| `1` (Thả) | `1` (Thả) | `0` | `0` | `0` | `r_Toggle` | Chỉ LED4 nhấp nháy, các LED còn lại TẮT[cite: 18] |

---

## Bảng ánh xạ chân vật lý & Timing Constraints

### Physical Constraints Mapping (`Lab5.cst`)
Tín hiệu được cấu hình trong file `Lab5.cst`:

| Tín hiệu Port | Chân FPGA | Linh kiện phần cứng | Cấu hình I/O (3.3V Bank VCCIO) |
| :--- | :---: | :--- | :--- |
| `i_Clk` | `T9` | System Clock (50 MHz) | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE`[cite: 16] |
| `i_Switch_1` | `B16` | Switch 1 / KEY0 | `IO_TYPE=LVCMOS33`, `PULL_MODE=UP`[cite: 16] |
| `i_Switch_2` | `A15` | Switch 2 / KEY1 | `IO_TYPE=LVCMOS33`, `PULL_MODE=UP`[cite: 16] |
| `o_LED_1` | `D14` | Output LED 1 / LED0 | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 16] |
| `o_LED_2` | `C14` | Output LED 2 / LED1 | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 16] |
| `o_LED_3` | `B9` | Output LED 3 / LED2 | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 16] |
| `o_LED_4` | `A9` | Output LED 4 / LED3 | `IO_TYPE=LVCMOS33`, `PULL_MODE=NONE`, `DRIVE=8mA`[cite: 16] |

### Timing Constraints (`Lab5.sdc`)
Ràng buộc thời gian cho xung nhịp 50 MHz định nghĩa trong file `Lab5.sdc`:
```tcl
create_clock -name i_Clk -period 20 -waveform {0 10} [get_ports {i_Clk}]
