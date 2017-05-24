from django.test import TestCase
import os

# Create your tests here.


PROJECT_DIR = os.path.dirname(os.path.dirname(__file__))
p=os.path.join(PROJECT_DIR, 'templates'),

print(p)