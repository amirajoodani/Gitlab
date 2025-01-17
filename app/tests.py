from django.test import TestCase

class SimpleTest(TestCase):
    def test_basic_addtion(self):
        self.assertEqual(1+1,2)

