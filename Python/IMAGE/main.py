import os
import time
from PIL import Image, ImageDraw
from multiprocessing import Pool, cpu_count

OUTPUT_DIR = "processed"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def process_image(img_path):
    base_name = os.path.basename(img_path)
    output_path = os.path.join(OUTPUT_DIR, f"out_{base_name}")
    
    with Image.open(img_path) as img:
        img = img.rotate(-90, expand=True)
        img = img.resize((800, 600), Image.LANCZOS)
        img = img.convert('L')
        img.save(output_path)

def create_test_images():
    os.makedirs("test_images", exist_ok=True)
    images = []
    
    # Фото 0 - красный фон, стрелка вверх
    img = Image.new('RGB', (600, 400), color=(255, 0, 0))
    draw = ImageDraw.Draw(img)
    draw.polygon([(300, 50), (250, 150), (280, 150), (280, 350), (320, 350), (320, 150), (350, 150)], fill=(255, 255, 0))
    img.save("test_images/img_0.jpg")
    images.append("test_images/img_0.jpg")
    
    # Фото 1 - зеленый фон, стрелка вниз
    img = Image.new('RGB', (600, 400), color=(0, 255, 0))
    draw = ImageDraw.Draw(img)
    draw.polygon([(300, 350), (250, 250), (280, 250), (280, 50), (320, 50), (320, 250), (350, 250)], fill=(255, 0, 0))
    img.save("test_images/img_1.jpg")
    images.append("test_images/img_1.jpg")
    
    # Фото 2 - синий фон, стрелка влево
    img = Image.new('RGB', (600, 400), color=(0, 0, 255))
    draw = ImageDraw.Draw(img)
    draw.polygon([(50, 200), (150, 150), (150, 180), (350, 180), (350, 220), (150, 220), (150, 250)], fill=(255, 255, 0))
    img.save("test_images/img_2.jpg")
    images.append("test_images/img_2.jpg")
    
    return images

def main():
    images = create_test_images()
    
    mode = input("Режим (1 - последовательно, 2 - параллельно): ")
    
    if mode == "1":
        start = time.time()
        for img in images:
            process_image(img)
        print(f"Время: {time.time() - start:.3f} сек")
    
    elif mode == "2":
        start = time.time()
        with Pool(cpu_count()) as p:
            p.map(process_image, images)
        print(f"Время: {time.time() - start:.3f} сек")

if __name__ == "__main__":
    main()