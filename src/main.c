#include "stdio.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "esp_log.h"

#define LED_PIN GPIO_NUM_2

void app_main(void) {

    const char *TAG ="LED BLINK WITH C";

    gpio_reset_pin(LED_PIN);
    gpio_set_direction(LED_PIN, GPIO_MODE_OUTPUT);

    printf("ESP32 is started! blinking LED");
    ESP_LOGI(TAG,"\nLED blinking initialized\n\n");


    while (1)
    {
        gpio_set_level(LED_PIN, 1);
        ESP_LOGI(TAG,"LED ON");
        vTaskDelay(500/portTICK_PERIOD_MS);

        gpio_set_level(LED_PIN, 0);
        ESP_LOGI(TAG,"LED OFF");
        vTaskDelay(500/portTICK_PERIOD_MS);
    }
    
}
