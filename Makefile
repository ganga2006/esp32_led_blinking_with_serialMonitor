PROJECT_NAME := led_blink

IDF_PATH ?= $(HOME)/esp/esp-idf
CC := xtensa-esp32-elf-gcc

BUILD_DIR := build
SRC_DIR := src
SRC_FILES := $(SRC_DIR)/main.c

CFLAGS := -I$(IDF_PATH)/components/freertos/include \
          -I$(IDF_PATH)/components/esp_common/include \
          -I$(IDF_PATH)/components/driver/include \
          -I$(IDF_PATH)/components/esp_system/include \
          -I$(IDF_PATH)/components/esp_rom/include \
          -I$(IDF_PATH)/components/newlib/platform_include \
          -I$(IDF_PATH)/components/xtensa/include \
          -I$(IDF_PATH)/components/soc/esp32/include

LDFLAGS := -L$(IDF_PATH)/components/esp_system -L$(IDF_PATH)/components/driver \
           -L$(IDF_PATH)/components/freertos -L$(IDF_PATH)/components/newlib \
           -L$(IDF_PATH)/components/esp_common -L$(IDF_PATH)/components/soc/esp32

LIBS := -lfreertos -lesp_common -lesp_system -ldriver -lm -lgcc

OUT := $(BUILD_DIR)/$(PROJECT_NAME).elf

all: $(OUT)

$(OUT): $(SRC_FILES)
	@mkdir -p $(BUILD_DIR)
	$(CC) -nostdlib -Wl,-EL -T $(IDF_PATH)/components/esp_rom/esp32/ld/esp32.rom.ld \
		$(CFLAGS) $^ -o $@ $(LDFLAGS) $(LIBS)

flash: $(OUT)
	esptool.py --chip esp32 elf2image --flash_mode dio --flash_freq 40m --flash_size 4MB -o $(BUILD_DIR)/$(PROJECT_NAME).bin $< && \
	esptool.py --chip esp32 --port /dev/ttyUSB0 write_flash -z 0x10000 $(BUILD_DIR)/$(PROJECT_NAME).bin

clean:
	rm -rf $(BUILD_DIR)
