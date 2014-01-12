package de.wwu.pi.mdsd.crudDsl.tests.util

import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import static extension de.wwu.pi.mdsd.crudDsl.util.ModelUtil.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.EntryWindow
import org.junit.Assert
import de.wwu.pi.mdsd.crudDsl.CrudDslInjectorProvider
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel

@RunWith(typeof(XtextRunner)) 
@InjectWith(typeof(CrudDslInjectorProvider))
class UtilTest {
	@Inject extension ParseHelper<CrudModel>
	@Inject extension ValidationTestHelper
	
	@Test
	def testGetVertexes() {
		val model = '''
		package test.test
		
		entity Test {
			att name : String
		}
		
		EntryWindow window for Test size= (200, 200) title "window title" {
			Field someField for name bounds= (50, 60, 70, 80) 
			Field someField2 for name bounds= (51, 61, 5, 15)
			
			Button save createEdit bounds= (121, 60, 5, 15)
		}
		'''
		val entryWindow = (model.parse.windows.head as EntryWindow)
		
		val bounds = entryWindow.allFields.head.getBounds
		val vertexes = bounds.vertexes
		
		//Test if vertexes are correctly determined
		Assert.assertTrue(vertexes.exists[it.key == 50 && it.value == 60])
		Assert.assertTrue(vertexes.exists[it.key == 120 && it.value == 60])
		Assert.assertTrue(vertexes.exists[it.key == 50 && it.value == 140])
		Assert.assertTrue(vertexes.exists[it.key == 120 && it.value == 140])
		
		//each vertex must be within bounds
		(vertexes + 
			#[	new Pair<Integer,Integer>(51,61),
				new Pair<Integer,Integer>(119,61),
				new Pair<Integer,Integer>(51,139),
				new Pair<Integer,Integer>(119,139)
		]).forEach[
			Assert.assertTrue(it.key + "-->" + it.value, bounds.pointWithinBounds(it))
		]
		
		//each vertex must not be within the bounds
		(	#[	new Pair<Integer,Integer>(49,59),
				new Pair<Integer,Integer>(121,59),
				new Pair<Integer,Integer>(49,141),
				new Pair<Integer,Integer>(121,141)
		]).forEach[
			Assert.assertFalse(it.key + "-->" + it.value, bounds.pointWithinBounds(it))
		]
		Assert.assertTrue("should overlap",
			entryWindow.allFields.head.uiOverlaps(entryWindow.allFields.tail.head))
			
		Assert.assertFalse("should not overlap",
			entryWindow.elements.head.uiOverlaps(entryWindow.elements.last)
		)
	}
}
